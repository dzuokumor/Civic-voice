import os
from datetime import datetime
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_migrate import Migrate
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_caching import Cache

from models import db
from routes import api

def create_app():
    app = Flask(__name__)

    app.config['SECRET_KEY'] = 'dev-secret-key-hardcoded'
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///civicvoice.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)
    CORS(app, origins=['*'])
    migrate = Migrate(app, db)

    limiter = Limiter(
        key_func=get_remote_address,
        app=app,
        default_limits=["1000 per hour"],
        storage_uri="memory://"
    )

    cache = Cache(app, config={'CACHE_TYPE': 'simple'})

    app.register_blueprint(api, url_prefix='/api')

    with app.app_context():
        db.create_all()

    return app

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
            'login': '/api/auth/login',
            'register': '/api/auth/register',
            'reports': '/api/reports'
        }
    })

@app.route('/favicon.ico')
def favicon():
    return '', 204

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    host = os.environ.get('HOST', '127.0.0.1')
    debug = True

    app.run(host=host, port=port, debug=debug)