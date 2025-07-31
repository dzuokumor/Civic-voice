from flask import Blueprint, request, jsonify, send_file
from uuid import UUID

from models import db, User, Report, VerificationLog, DataPurchase, ReportAttachment
from datetime import datetime, timedelta
import uuid
from werkzeug.security import check_password_hash
from functools import wraps
import jwt
import os
from utils import generate_reference_code, generate_passphrase, validate_file_upload, \
    save_file_upload, logger
import stripe
from io import BytesIO
import csv
import json

api = Blueprint('api', __name__)

stripe.api_key = os.environ.get('STRIPE_SECRET_KEY')

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'error': 'Token is missing'}), 401

        try:
            if token.startswith('Bearer '):
                token = token[7:]
            data = jwt.decode(token, os.environ.get('SECRET_KEY'), algorithms=['HS256'])
            current_user = User.query.get(data['user_id'])
            if not current_user:
                return jsonify({'error': 'User not found'}), 401
        except jwt.ExpiredSignatureError:
            return jsonify({'error': 'Token has expired'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'error': 'Invalid token'}), 401

        return f(current_user, *args, **kwargs)
    return decorated

def role_required(role):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            token = request.headers.get('Authorization')
            if not token:
                return jsonify({'error': 'Token is missing'}), 401

            try:
                if token.startswith('Bearer '):
                    token = token[7:]
                data = jwt.decode(token, os.environ.get('SECRET_KEY'), algorithms=['HS256'])
                current_user = User.query.get(data['user_id'])
                if not current_user or current_user.role != role:
                    return jsonify({'error': 'Insufficient permissions'}), 403
            except jwt.ExpiredSignatureError:
                return jsonify({'error': 'Token has expired'}), 401
            except jwt.InvalidTokenError:
                return jsonify({'error': 'Invalid token'}), 401

            return f(current_user, *args, **kwargs)
        return decorated_function
    return decorator

@api.route('/reports', methods=['POST'])
def submit_report():
    try:
        data = request.form.to_dict()

        required_fields = ['title', 'category', 'latitude', 'longitude']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'Missing required field: {field}'}), 400

        description = data.get('description', '')
        if len(description) > 2000:
            return jsonify({'error': 'Description exceeds 2000 characters'}), 400

        language = data.get('language', 'en')
        if language not in ['en', 'fr']:
            return jsonify({'error': 'Language must be en or fr'}), 400

        try:
            lat = float(data['latitude'])
            lng = float(data['longitude'])
            if not (-90 <= lat <= 90) or not (-180 <= lng <= 180):
                return jsonify({'error': 'Invalid coordinates'}), 400
        except ValueError:
            return jsonify({'error': 'Invalid coordinate format'}), 400

        report_id = str(uuid.uuid4())
        reference_code = generate_reference_code()
        passphrase = generate_passphrase()

        new_report = Report(
            id=report_id,
            title=data['title'][:200],
            category=data['category'],
            description=description,
            latitude=lat,
            longitude=lng,
            language=language,
            reference_code=reference_code,
            passphrase=passphrase
        )

        db.session.add(new_report)

        if 'attachment' in request.files:
            file = request.files['attachment']
            if file and file.filename:
                validation_result = validate_file_upload(file)
                if not validation_result['valid']:
                    return jsonify({'error': validation_result['error']}), 400

                file_path = save_file_upload(file, report_id)
                if file_path:
                    attachment = ReportAttachment(
                        id=str(uuid.uuid4()),
                        report_id=report_id,
                        filename=file.filename,
                        file_path=file_path,
                        file_size=validation_result['size'],
                        content_type=file.content_type
                    )
                    db.session.add(attachment)

        db.session.commit()

        return jsonify({
            'message': 'Report submitted successfully',
            'reference_code': reference_code,
            'passphrase': passphrase,
            'report_id': report_id
        }), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/reports/track', methods=['POST'])
def track_report():
    try:
        data = request.get_json()

        if not data or 'reference_code' not in data or 'passphrase' not in data:
            return jsonify({'error': 'Reference code and passphrase are required'}), 400

        report = Report.query.filter_by(
            reference_code=data['reference_code'],
            passphrase=data['passphrase']
        ).first()

        if not report:
            return jsonify({'error': 'Invalid reference code or passphrase'}), 404

        logs = VerificationLog.query.filter_by(report_id=report.id) \
            .order_by(VerificationLog.created_at.desc()).all()

        return jsonify({
            'report': {
                'id': report.id,
                'title': report.title,
                'category': report.category,
                'status': report.status,
                'submitted_at': report.created_at.isoformat(),
                'last_updated': report.updated_at.isoformat()
            },
            'status_history': [{
                'action': log.action,
                'notes': log.notes,
                'timestamp': log.created_at.isoformat()
            } for log in logs]
        })

    except Exception as e:
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/login', methods=['POST'])
def login():
    try:
        data = request.get_json()

        if not data or 'email' not in data or 'password' not in data:
            return jsonify({'error': 'Email and password are required'}), 400

        user = User.query.filter_by(email=data['email']).first()

        if not user or not check_password_hash(user.password_hash, data['password']):
            return jsonify({'error': 'Invalid credentials'}), 401

        token = jwt.encode({
            'user_id': user.id,
            'role': user.role,
            'exp': datetime.utcnow() + timedelta(hours=24)
        }, os.environ.get('SECRET_KEY'), algorithm='HS256')

        return jsonify({
            'token': token,
            'user': {
                'id': user.id,
                'email': user.email,
                'role': user.role
            }
        })

    except Exception as e:
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/moderator/test', methods=['GET'])
def moderator_test():
    return jsonify({'message': 'moderator route works'})

@api.route('/moderator/reports', methods=['GET'])
def list_reports_for_moderation():
    try:
        status = request.args.get('status', 'pending')
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 10, type=int)
        category = request.args.get('category')

        query = Report.query.filter_by(status=status)

        if category:
            query = query.filter_by(category=category)

        reports = query.order_by(Report.created_at.desc()) \
            .paginate(page=page, per_page=per_page, error_out=False)

        return jsonify({
            'reports': [{
                'id': report.id,
                'title': report.title,
                'category': report.category,
                'description': report.description,
                'latitude': report.latitude,
                'longitude': report.longitude,
                'language': report.language,
                'status': report.status,
                'created_at': report.created_at.isoformat(),
                'has_attachment': len(report.attachments) > 0
            } for report in reports.items],
            'pagination': {
                'total': reports.total,
                'pages': reports.pages,
                'current_page': reports.page,
                'per_page': reports.per_page,
                'has_prev': reports.has_prev,
                'has_next': reports.has_next
            }
        })

    except Exception as e:
        return jsonify({'error': f'Internal server error: {str(e)}'}), 500

@api.route('/moderator/reports-test', methods=['GET'])
def moderator_reports_test():
    return jsonify({'message': 'moderator reports test works'})

@api.route('/moderator/reports/<report_id>', methods=['GET'])
def get_report_details(report_id):
    try:
        report = Report.query.get(report_id)
        if not report:
            return jsonify({'error': 'Report not found'}), 404

        logs = (
            VerificationLog.query
            .filter_by(report_id=report_id)
            .order_by(VerificationLog.created_at.desc())
            .all()
        )

        return jsonify({
            'report': {
                'id': report.id,
                'title': report.title,
                'category': report.category,
                'description': report.description,
                'latitude': report.latitude,
                'longitude': report.longitude,
                'language': report.language,
                'status': report.status,
                'created_at': report.created_at.isoformat(),
                'updated_at': report.updated_at.isoformat() if report.updated_at else None,
                'has_attachment': bool(getattr(report, "attachments", []))
            },
            'status_history': [
                {
                    'action': log.action,
                    'notes': log.notes,
                    'timestamp': log.created_at.isoformat(),
                    'moderator_id': log.user_id
                } for log in logs
            ]
        })

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Internal server error', 'details': str(e)}), 500

@api.route('/moderator/reports/<report_id>/verify', methods=['POST'])
@role_required('moderator')
def verify_report(current_user, report_id):
    try:
        data = request.get_json()

        if not data or 'action' not in data or data['action'] not in ['verified', 'rejected']:
            return jsonify({'error': 'Action must be verified or rejected'}), 400

        report = Report.query.get(report_id)
        if not report:
            return jsonify({'error': 'Report not found'}), 404

        if report.status != 'pending':
            return jsonify({'error': 'Report has already been processed'}), 400

        report.status = data['action']
        report.updated_at = datetime.utcnow()

        log = VerificationLog(
            id=str(uuid.uuid4()),
            report_id=report_id,
            user_id=current_user.id,
            action=data['action'],
            notes=data.get('notes', '')
        )

        db.session.add(log)
        db.session.commit()

        return jsonify({
            'message': f'Report {data["action"]} successfully',
            'report': {
                'id': report.id,
                'status': report.status,
                'updated_at': report.updated_at.isoformat()
            }
        })

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/public/reports', methods=['GET'])
def public_reports():
    try:
        category = request.args.get('category')
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 50, type=int)

        query = Report.query.filter_by(status='verified')

        if category:
            query = query.filter_by(category=category)

        if start_date:
            try:
                start_dt = datetime.fromisoformat(start_date)
                query = query.filter(Report.created_at >= start_dt)
            except ValueError:
                return jsonify({'error': 'Invalid start_date format'}), 400

        if end_date:
            try:
                end_dt = datetime.fromisoformat(end_date)
                query = query.filter(Report.created_at <= end_dt)
            except ValueError:
                return jsonify({'error': 'Invalid end_date format'}), 400

        reports = query.order_by(Report.created_at.desc()) \
            .paginate(page=page, per_page=per_page, error_out=False)

        return jsonify({
            'reports': [{
                'id': report.id,
                'title': report.title,
                'category': report.category,
                'description': report.description,
                'latitude': report.latitude,
                'longitude': report.longitude,
                'created_at': report.created_at.isoformat(),
                'language': report.language
            } for report in reports.items],
            'pagination': {
                'total': reports.total,
                'pages': reports.pages,
                'current_page': reports.page,
                'per_page': reports.per_page
            }
        })

    except Exception as e:
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/register/researcher', methods=['POST'])
def register_researcher():
    try:
        data = request.get_json()

        required_fields = ['email', 'password', 'organization']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'Missing required field: {field}'}), 400

        if User.query.filter_by(email=data['email']).first():
            return jsonify({'error': 'Email already registered'}), 400

        researcher = User(
            id=str(uuid.uuid4()),
            email=data['email'],
            role='researcher',
            organization=data['organization'],
            email_verified=False  # TODO: Implement email verification
        )
        researcher.set_password(data['password'])

        db.session.add(researcher)
        db.session.commit()

        # TODO: Send verification email

        return jsonify({
            'message': 'Researcher account created successfully',
            'user_id': researcher.id
        }), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/data/purchase', methods=['POST'])
@role_required('researcher')
def purchase_data(current_user):
    try:
        data = request.get_json()

        filters = data.get('filters', {})
        price_per_report = 0.50  # TODO: Make configurable

        query = Report.query.filter_by(status='verified')

        if filters.get('category'):
            query = query.filter_by(category=filters['category'])

        if filters.get('start_date'):
            start_dt = datetime.fromisoformat(filters['start_date'])
            query = query.filter(Report.created_at >= start_dt)

        if filters.get('end_date'):
            end_dt = datetime.fromisoformat(filters['end_date'])
            query = query.filter(Report.created_at <= end_dt)

        report_count = query.count()
        total_amount = int(report_count * price_per_report * 100)

        if total_amount == 0:
            return jsonify({'error': 'No reports match the specified criteria'}), 400

        intent = stripe.PaymentIntent.create(
            amount=total_amount,
            currency='usd',
            metadata={
                'user_id': current_user.id,
                'report_count': report_count,
                'filters': json.dumps(filters)
            }
        )

        return jsonify({
            'client_secret': intent.client_secret,
            'report_count': report_count,
            'total_amount': total_amount / 100,
            'payment_intent_id': intent.id
        })

    except Exception as e:
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/data/confirm-purchase', methods=['POST'])
@role_required('researcher')
def confirm_purchase(current_user):
    try:
        data = request.get_json()
        payment_intent_id = data.get('payment_intent_id')

        if not payment_intent_id:
            return jsonify({'error': 'Payment intent ID is required'}), 400

        intent = stripe.PaymentIntent.retrieve(payment_intent_id)

        if intent.status != 'succeeded':
            return jsonify({'error': 'Payment not completed'}), 400

        if intent.metadata.get('user_id') != current_user.id:
            return jsonify({'error': 'Unauthorized'}), 403

        purchase = DataPurchase(
            id=str(uuid.uuid4()),
            user_id=current_user.id,
            stripe_payment_intent_id=payment_intent_id,
            amount=intent.amount / 100,
            report_count=int(intent.metadata.get('report_count', 0)),
            filters=intent.metadata.get('filters', '{}'),
            expires_at=datetime.utcnow() + timedelta(hours=24)
        )

        db.session.add(purchase)
        db.session.commit()

        return jsonify({
            'message': 'Purchase confirmed successfully',
            'download_token': purchase.id,
            'expires_at': purchase.expires_at.isoformat()
        })

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/data/download/<download_token>', methods=['GET'])
@role_required('researcher')
def download_data(current_user, download_token):
    try:
        purchase = DataPurchase.query.filter_by(
            id=download_token,
            user_id=current_user.id
        ).first()

        if not purchase:
            return jsonify({'error': 'Invalid download token'}), 404

        if purchase.expires_at < datetime.utcnow():
            return jsonify({'error': 'Download link has expired'}), 410

        filters = json.loads(purchase.filters)

        query = Report.query.filter_by(status='verified')

        if filters.get('category'):
            query = query.filter_by(category=filters['category'])

        if filters.get('start_date'):
            start_dt = datetime.fromisoformat(filters['start_date'])
            query = query.filter(Report.created_at >= start_dt)

        if filters.get('end_date'):
            end_dt = datetime.fromisoformat(filters['end_date'])
            query = query.filter(Report.created_at <= end_dt)

        reports = query.all()

        output = BytesIO()
        writer = csv.writer(output.getvalue().decode('utf-8'))

        writer.writerow([
            'report_id', 'title', 'category', 'description',
            'latitude', 'longitude', 'language', 'created_at'
        ])

        for report in reports:
            writer.writerow([
                report.id, report.title, report.category,
                report.description, report.latitude, report.longitude,
                report.language, report.created_at.isoformat()
            ])

        output.seek(0)

        return send_file(
            output,
            mimetype='text/csv',
            as_attachment=True,
            download_name=f'civic_reports_{datetime.utcnow().strftime("%Y%m%d_%H%M%S")}.csv'
        )

    except Exception as e:
        return jsonify({'error': 'Internal server error'}), 500
@api.route('/health', methods=['GET'])
def health_check():
    try:
        User.query.first()

        return jsonify({
            'status': 'healthy',
            'timestamp': datetime.utcnow().isoformat(),
            'version': '1.0.0'
        })
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'error': str(e)
        }), 500

@api.route('/categories', methods=['GET'])
def get_categories():
    categories = [
        'corruption',
        'infrastructure',
        'healthcare',
        'education',
        'environment',
        'public_safety',
        'transportation',
        'housing',
        'employment',
        'other'
    ]

    return jsonify({'categories': categories})

@api.route('/auth/register', methods=['POST'])
def register():
    try:
        data = request.get_json()

        required_fields = ['email', 'password', 'user_type']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'Missing required field: {field}'}), 400

        user_type = data['user_type']
        if user_type not in ['researcher', 'moderator']:
            return jsonify({'error': 'Invalid user type. Must be researcher or moderator'}), 400

        if User.query.filter_by(email=data['email']).first():
            return jsonify({'error': 'Email already registered'}), 400

        password = data['password']
        if len(password) < 8:
            return jsonify({'error': 'Password must be at least 8 characters long'}), 400

        if not any(c.isupper() for c in password):
            return jsonify({'error': 'Password must contain at least one uppercase letter'}), 400

        if not any(c.islower() for c in password):
            return jsonify({'error': 'Password must contain at least one lowercase letter'}), 400

        if not any(c.isdigit() for c in password):
            return jsonify({'error': 'Password must contain at least one number'}), 400

        user = User(
            id=str(uuid.uuid4()),
            email=data['email'],
            role=user_type,
            organization=data.get('organization', 'General User'),
            email_verified=False
        )
        user.set_password(password)

        db.session.add(user)
        db.session.commit()

        try:
            from utils import send_verification_email
            send_verification_email(user.email, user.id)
        except Exception as email_error:
            logger.warning(f"Failed to send verification email: {email_error}")

        return jsonify({
            'message': f'{user_type.title()} account created successfully',
            'user_id': user.id,
            'email_verification_required': True
        }), 201

    except Exception as e:
        db.session.rollback()
        logger.error(f"Registration error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/verify-email', methods=['POST'])
def verify_email():
    try:
        data = request.get_json()

        if not data or 'token' not in data:
            return jsonify({'error': 'Verification token is required'}), 400

        from utils import verify_email_token
        result = verify_email_token(data['token'])

        if not result['valid']:
            return jsonify({'error': result['error']}), 400

        return jsonify({
            'message': 'Email verified successfully',
            'user_id': result['user_id']
        })

    except Exception as e:
        logger.error(f"Email verification error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/resend-verification', methods=['POST'])
def resend_verification():
    try:
        data = request.get_json()

        if not data or 'email' not in data:
            return jsonify({'error': 'Email is required'}), 400

        user = User.query.filter_by(email=data['email']).first()
        if not user:
            return jsonify({'error': 'User not found'}), 404

        if user.email_verified:
            return jsonify({'error': 'Email already verified'}), 400

        from utils import send_verification_email
        if send_verification_email(user.email, user.id):
            return jsonify({'message': 'Verification email sent successfully'})
        else:
            return jsonify({'error': 'Failed to send verification email'}), 500

    except Exception as e:
        logger.error(f"Resend verification error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/forgot-password', methods=['POST'])
def forgot_password():
    try:
        data = request.get_json()

        if not data or 'email' not in data:
            return jsonify({'error': 'Email is required'}), 400

        user = User.query.filter_by(email=data['email']).first()
        if not user:
            return jsonify({'message': 'If the email exists, a reset link has been sent'})

        from utils import generate_password_reset_token, send_password_reset_email
        reset_token = generate_password_reset_token(user.id)

        if send_password_reset_email(user.email, reset_token):
            return jsonify({'message': 'If the email exists, a reset link has been sent'})
        else:
            return jsonify({'error': 'Failed to send reset email'}), 500

    except Exception as e:
        logger.error(f"Forgot password error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/reset-password', methods=['POST'])
def reset_password():
    try:
        data = request.get_json()

        required_fields = ['token', 'new_password']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'Missing required field: {field}'}), 400

        from utils import verify_password_reset_token
        result = verify_password_reset_token(data['token'])

        if not result['valid']:
            return jsonify({'error': result['error']}), 400

        user = User.query.get(result['user_id'])
        if not user:
            return jsonify({'error': 'User not found'}), 404

        new_password = data['new_password']
        if len(new_password) < 8:
            return jsonify({'error': 'Password must be at least 8 characters long'}), 400

        user.set_password(new_password)
        db.session.commit()

        return jsonify({'message': 'Password reset successfully'})

    except Exception as e:
        db.session.rollback()
        logger.error(f"Reset password error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/change-password', methods=['POST'])
@token_required
def change_password(current_user):
    try:
        data = request.get_json()

        required_fields = ['current_password', 'new_password']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'Missing required field: {field}'}), 400

        if not check_password_hash(current_user.password_hash, data['current_password']):
            return jsonify({'error': 'Current password is incorrect'}), 400

        new_password = data['new_password']
        if len(new_password) < 8:
            return jsonify({'error': 'Password must be at least 8 characters long'}), 400

        current_user.set_password(new_password)
        db.session.commit()

        return jsonify({'message': 'Password changed successfully'})

    except Exception as e:
        db.session.rollback()
        logger.error(f"Change password error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/profile', methods=['GET'])
@token_required
def get_profile(current_user):
    try:
        return jsonify({
            'user': current_user.to_dict()
        })

    except Exception as e:
        logger.error(f"Get profile error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.route('/auth/profile', methods=['PUT'])
@token_required
def update_profile(current_user):
    try:
        data = request.get_json()

        allowed_fields = ['organization']

        for field in allowed_fields:
            if field in data:
                setattr(current_user, field, data[field])

        db.session.commit()

        return jsonify({
            'message': 'Profile updated successfully',
            'user': current_user.to_dict()
        })

    except Exception as e:
        db.session.rollback()
        logger.error(f"Update profile error: {str(e)}")
        return jsonify({'error': 'Internal server error'}), 500

@api.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404

@api.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

