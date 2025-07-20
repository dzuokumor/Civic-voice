import os
import logging
from datetime import datetime
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_migrate import Migrate
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_caching import Cache
import stripe

from models import db
from routes import api
from config import get_config
from utils import cleanup_expired_downloads

def create_app(config_name=None):
    app = Flask(__name__)

    if config_name is None:
        config_name = os.environ.get('FLASK_ENV', 'development')

    config_class = get_config()
    app.config.from_object(config_class)

    setup_logging(app)

    db.init_app(app)

    CORS(app, origins=app.config['CORS_ORIGINS'])

    migrate = Migrate(app, db)

    limiter = Limiter(
        app,
        key_func=get_remote_address,
        default_limits=[app.config.get('RATELIMIT_DEFAULT', '100 per hour')],
        storage_uri=app.config.get('RATELIMIT_STORAGE_URL', 'memory://')
    )

    cache = Cache(app)

    if app.config.get('STRIPE_SECRET_KEY'):
        stripe.api_key = app.config['STRIPE_SECRET_KEY']

    app.register_blueprint(api, url_prefix='/api')

    register_error_handlers(app)

    register_cli_commands(app)

    register_middleware(app)

    with app.app_context():
        db.create_all()

        initialize_system_settings()

    app.logger.info(f"CivicVoice application started in {config_name} mode")

    return app

def setup_logging(app):
    if not app.debug and not app.testing:
        if app.config.get('LOG_FILE'):
            file_handler = logging.FileHandler(app.config['LOG_FILE'])
            file_handler.setFormatter(logging.Formatter(
                '[%(asctime)s] %(levelname)s in %(module)s: %(message)s'
            ))
            file_handler.setLevel(getattr(logging, app.config.get('LOG_LEVEL', 'INFO')))
            app.logger.addHandler(file_handler)

        console_handler = logging.StreamHandler()
        console_handler.setFormatter(logging.Formatter(
            '[%(asctime)s] %(levelname)s: %(message)s'
        ))
        console_handler.setLevel(getattr(logging, app.config.get('LOG_LEVEL', 'INFO')))
        app.logger.addHandler(console_handler)

        app.logger.setLevel(getattr(logging, app.config.get('LOG_LEVEL', 'INFO')))

def register_error_handlers(app):

    @app.errorhandler(400)
    def bad_request(error):
        return jsonify({
            'error': 'Bad request',
            'message': 'The request could not be understood by the server'
        }), 400

    @app.errorhandler(401)
    def unauthorized(error):
        return jsonify({
            'error': 'Unauthorized',
            'message': 'Authentication is required'
        }), 401

    @app.errorhandler(403)
    def forbidden(error):
        return jsonify({
            'error': 'Forbidden',
            'message': 'You do not have permission to access this resource'
        }), 403

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
            'error': 'Not found',
            'message': 'The requested resource was not found'
        }), 404

    @app.errorhandler(429)
    def ratelimit_handler(error):
        return jsonify({
            'error': 'Rate limit exceeded',
            'message': 'Too many requests. Please try again later.'
        }), 429

    @app.errorhandler(500)
    def internal_error(error):
        db.session.rollback()
        app.logger.error(f"Internal server error: {str(error)}")
        return jsonify({
            'error': 'Internal server error',
            'message': 'An unexpected error occurred'
        }), 500

def register_middleware(app):

    @app.before_request
    def before_request():
        if not request.endpoint or request.endpoint == 'static':
            return

        if request.endpoint != 'api.health_check':
            app.logger.info(f"{request.method} {request.path} from {request.remote_addr}")

    @app.after_request
    def after_request(response):
        security_headers = app.config.get('SECURITY_HEADERS', {})
        for header, value in security_headers.items():
            response.headers[header] = value

        if request.method == 'OPTIONS':
            response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
            response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'

        return response

def register_cli_commands(app):

    @app.cli.command()
    def init_db():
        db.create_all()
        print("Database initialized!")

    @app.cli.command()
    def create_moderator():
        from utils import create_moderator_account

        email = input("Enter moderator email: ")
        password = input("Enter password: ")
        organization = input("Enter organization (optional): ") or None

        result = create_moderator_account(email, password, organization)
        if result['success']:
            print(f"Moderator account created successfully! User ID: {result['user_id']}")
        else:
            print(f"Error: {result['error']}")

    @app.cli.command()
    def cleanup_downloads():
        count = cleanup_expired_downloads()
        print(f"Found {count} expired download tokens")

    @app.cli.command()
    def generate_analytics():
        from utils import generate_analytics_report
        import json

        analytics = generate_analytics_report()
        if analytics:
            print("Analytics Report:")
            print(json.dumps(analytics, indent=2))
        else:
            print("Failed to generate analytics report")

    @app.cli.command()
    def backup_db():
        from utils import backup_database

        result = backup_database()
        if result['success']:
            print(f"Backup created: {result['filename']}")
        else:
            print(f"Backup failed: {result['error']}")

def initialize_system_settings():
    from utils import set_system_setting, get_system_setting

    # Set default settings if they don't exist
    default_settings = {
        'data_price_per_report': '0.50',
        'max_file_size_mb': '10',
        'supported_languages': 'en,fr',
        'admin_email': 'admin@civicvoice.app',
        'site_name': 'CivicVoice',
        'maintenance_mode': 'false'
    }

    for key, value in default_settings.items():
        if get_system_setting(key) is None:
            set_system_setting(key, value, f"Default {key.replace('_', ' ')}")

app = create_app()

@app.route('/')
def index():
    return jsonify({
        'name': 'CivicVoice API',
        'version': '1.0.0',
        'status': 'running',
        'timestamp': datetime.utcnow().isoformat(),
        'endpoints': {
            'health': '/api/health',
            'reports': '/api/reports',
            'public_dashboard': '/api/public/reports',
            'track_report': '/api/reports/track',
            'login': '/api/auth/login',
            'register_researcher': '/api/auth/register/researcher'
        }
    })

@app.route('/favicon.ico')
def favicon():
    return '', 204

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    host = os.environ.get('HOST', '127.0.0.1')
    debug = os.environ.get('FLASK_ENV') == 'development'

    app.run(host=host, port=port, debug=debug)