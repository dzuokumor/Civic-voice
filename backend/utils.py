import uuid
import os
import secrets
import string
from typing import Dict, Any, Optional, Union, List
from werkzeug.utils import secure_filename
from datetime import datetime
import logging

try:
    from PIL import Image
except ImportError:
    Image = None

try:
    from email.mime.text import MimeText
    from email.mime.multipart import MimeMultipart
except ImportError:
    MimeText = None
    MimeMultipart = None

try:
    import jwt
except ImportError:
    jwt = None

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

UPLOAD_FOLDER = os.environ.get('UPLOAD_FOLDER', 'uploads')
MAX_FILE_SIZE = 10 * 1024 * 1024
ALLOWED_EXTENSIONS = {
    'images': {'png', 'jpg', 'jpeg', 'gif', 'webp'},
    'documents': {'pdf', 'doc', 'docx', 'txt'},
    'all': {'png', 'jpg', 'jpeg', 'gif', 'webp', 'pdf', 'doc', 'docx', 'txt'}
}

def generate_reference_code() -> str:
    return ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(8))

def generate_passphrase() -> str:
    words = [
        'apple', 'brave', 'chair', 'dance', 'eagle', 'flame', 'grace', 'heart',
        'ivory', 'jolly', 'kraft', 'lemon', 'music', 'novel', 'ocean', 'peace',
        'queen', 'river', 'smile', 'tower', 'unity', 'voice', 'water', 'youth'
    ]

    passphrase_words = secrets.SystemRandom().sample(words, 3)
    random_number = secrets.randbelow(999) + 1

    return f"{'-'.join(passphrase_words)}-{random_number:03d}"

def allowed_file(filename: str, file_type: str = 'all') -> bool:
    if '.' not in filename:
        return False

    extension = filename.rsplit('.', 1)[1].lower()
    return extension in ALLOWED_EXTENSIONS.get(file_type, ALLOWED_EXTENSIONS['all'])

def validate_file_upload(file) -> Dict[str, Any]:
    try:
        if not file or not file.filename:
            return {'valid': False, 'error': 'No file provided'}

        if not allowed_file(file.filename):
            return {'valid': False, 'error': 'File type not allowed'}

        file.seek(0, os.SEEK_END)
        file_size = file.tell()
        file.seek(0)

        if file_size > MAX_FILE_SIZE:
            return {'valid': False, 'error': f'File size exceeds {MAX_FILE_SIZE // (1024*1024)}MB limit'}

        if file_size == 0:
            return {'valid': False, 'error': 'File is empty'}

        if Image and file.content_type and file.content_type.startswith('image/'):
            try:
                file.seek(0)
                with Image.open(file) as img:
                    img.verify()
                file.seek(0)
            except Exception:
                return {'valid': False, 'error': 'Invalid or corrupted image file'}

        return {'valid': True, 'size': file_size}

    except Exception as e:
        logger.error(f"File validation error: {str(e)}")
        return {'valid': False, 'error': 'File validation failed'}

def save_file_upload(file, report_id: str) -> Optional[str]:
    try:
        if not os.path.exists(UPLOAD_FOLDER):
            os.makedirs(UPLOAD_FOLDER, exist_ok=True)

        report_dir = os.path.join(UPLOAD_FOLDER, report_id)
        os.makedirs(report_dir, exist_ok=True)

        filename = secure_filename(file.filename)

        name, ext = os.path.splitext(filename)
        timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
        unique_filename = f"{name}_{timestamp}{ext}"

        file_path = os.path.join(report_dir, unique_filename)

        file.save(file_path)

        return os.path.join(report_id, unique_filename)

    except Exception as e:
        logger.error(f"File save error: {str(e)}")
        return None

def delete_file_upload(file_path: str) -> bool:
    try:
        full_path = os.path.join(UPLOAD_FOLDER, file_path)
        if os.path.exists(full_path):
            os.remove(full_path)

            dir_path = os.path.dirname(full_path)
            try:
                os.rmdir(dir_path)
            except OSError:
                pass

        return True
    except Exception as e:
        logger.error(f"File deletion error: {str(e)}")
        return False

def create_moderator_account(email: str, password: str, organization: Optional[str] = None) -> Dict[str, Any]:
    try:
        from models import db, User

        if User.query.filter_by(email=email).first():
            return {'success': False, 'error': 'Email already exists'}

        moderator = User(
            id=str(uuid.uuid4()),
            email=email,
            role='moderator',
            organization=organization,
            email_verified=True
        )
        moderator.set_password(password)

        db.session.add(moderator)
        db.session.commit()

        logger.info(f"Moderator account created for {email}")
        return {'success': True, 'user_id': moderator.id}

    except Exception as e:
        try:
            from models import db
            db.session.rollback()
        except (ImportError, AttributeError):
            pass
        logger.error(f"Error creating moderator account: {str(e)}")
        return {'success': False, 'error': 'Failed to create account'}

def create_researcher_account(email: str, password: str, organization: str) -> Dict[str, Any]:
    try:
        from models import db, User

        if User.query.filter_by(email=email).first():
            return {'success': False, 'error': 'Email already exists'}

        researcher = User(
            id=str(uuid.uuid4()),
            email=email,
            role='researcher',
            organization=organization,
            email_verified=False
        )
        researcher.set_password(password)

        db.session.add(researcher)
        db.session.commit()

        send_verification_email(researcher.email, researcher.id)

        logger.info(f"Researcher account created for {email}")
        return {'success': True, 'user_id': researcher.id}

    except Exception as e:
        try:
            from models import db
            db.session.rollback()
        except (ImportError, AttributeError):
            pass
        logger.error(f"Error creating researcher account: {str(e)}")
        return {'success': False, 'error': 'Failed to create account'}

def send_verification_email(email: str, user_id: str) -> bool:
    try:
        verification_token = generate_verification_token(user_id)
        verification_url = f"{os.environ.get('FRONTEND_URL', 'http://localhost:3000')}/verify-email?token={verification_token}"

        subject = "Verify Your CivicVoice Account"
        body = f"""
        Hello,
        
        Thank you for registering with CivicVoice. Please click the link below to verify your email address:
        
        {verification_url}
        
        This link will expire in 24 hours.
        
        If you didn't create this account, please ignore this email.
        
        Best regards,
        The CivicVoice Team
        """

        logger.info(f"Verification email would be sent to {email}")
        logger.info(f"Verification URL: {verification_url}")

        return True

    except Exception as e:
        logger.error(f"Error sending verification email: {str(e)}")
        return False

def generate_verification_token(user_id: str) -> str:
    if not jwt:
        raise ImportError("PyJWT is required for token generation")

    from datetime import timedelta

    payload = {
        'user_id': user_id,
        'purpose': 'email_verification',
        'exp': datetime.utcnow() + timedelta(hours=24)
    }

    secret_key = os.environ.get('SECRET_KEY')
    if not secret_key:
        raise ValueError("SECRET_KEY environment variable is required")

    return jwt.encode(payload, secret_key, algorithm='HS256')

def verify_email_token(token: str) -> Dict[str, Any]:
    if not jwt:
        return {'valid': False, 'error': 'JWT library not available'}

    try:
        from models import db, User

        secret_key = os.environ.get('SECRET_KEY')
        if not secret_key:
            return {'valid': False, 'error': 'Secret key not configured'}

        payload = jwt.decode(token, secret_key, algorithms=['HS256'])

        if payload.get('purpose') != 'email_verification':
            return {'valid': False, 'error': 'Invalid token purpose'}

        user = User.query.get(payload['user_id'])
        if not user:
            return {'valid': False, 'error': 'User not found'}

        if user.email_verified:
            return {'valid': False, 'error': 'Email already verified'}

        user.email_verified = True
        db.session.commit()

        return {'valid': True, 'user_id': user.id}

    except jwt.ExpiredSignatureError:
        return {'valid': False, 'error': 'Token has expired'}
    except jwt.InvalidTokenError:
        return {'valid': False, 'error': 'Invalid token'}
    except Exception as e:
        logger.error(f"Email verification error: {str(e)}")
        return {'valid': False, 'error': 'Verification failed'}

def get_system_setting(key: str, default_value: Any = None) -> Any:
    try:
        from models import SystemSettings

        setting = SystemSettings.query.filter_by(key=key).first()
        return setting.value if setting else default_value
    except Exception:
        return default_value

def set_system_setting(key: str, value: Any, description: Optional[str] = None) -> bool:
    try:
        from models import db, SystemSettings

        setting = SystemSettings.query.filter_by(key=key).first()

        if setting:
            setting.value = str(value)
            setting.updated_at = datetime.utcnow()
            if description:
                setting.description = description
        else:
            setting = SystemSettings(
                id=str(uuid.uuid4()),
                key=key,
                value=str(value),
                description=description
            )
            db.session.add(setting)

        db.session.commit()
        return True

    except Exception as e:
        try:
            from models import db
            db.session.rollback()
        except (ImportError, AttributeError):
            pass
        logger.error(f"Error setting system setting: {str(e)}")
        return False

def anonymize_data(data: Union[Dict, List, Any]) -> Union[Dict, List, Any]:
    if isinstance(data, dict):
        sensitive_fields = ['reference_code', 'passphrase', 'email', 'password_hash']
        return {k: v for k, v in data.items() if k not in sensitive_fields}
    elif isinstance(data, list):
        return [anonymize_data(item) for item in data]
    else:
        return data

def validate_coordinates(latitude: Union[str, float], longitude: Union[str, float]) -> Dict[str, Any]:
    try:
        lat = float(latitude)
        lng = float(longitude)

        if not (-90 <= lat <= 90):
            return {'valid': False, 'error': 'Latitude must be between -90 and 90'}

        if not (-180 <= lng <= 180):
            return {'valid': False, 'error': 'Longitude must be between -180 and 180'}

        return {'valid': True, 'latitude': lat, 'longitude': lng}

    except (ValueError, TypeError):
        return {'valid': False, 'error': 'Invalid coordinate format'}

def sanitize_input(text: Optional[str], max_length: Optional[int] = None) -> str:
    if not text:
        return ''

    sanitized = ''.join(char for char in text if ord(char) >= 32 or char in '\n\r\t')

    sanitized = sanitized.strip()

    if max_length and len(sanitized) > max_length:
        sanitized = sanitized[:max_length]

    return sanitized

def generate_analytics_report() -> Optional[Dict[str, Any]]:
    try:
        from models import Report, User, DataPurchase, db
        from sqlalchemy import func

        total_reports = Report.query.count()
        pending_reports = Report.query.filter_by(status='pending').count()
        verified_reports = Report.query.filter_by(status='verified').count()
        rejected_reports = Report.query.filter_by(status='rejected').count()

        total_moderators = User.query.filter_by(role='moderator').count()
        total_researchers = User.query.filter_by(role='researcher').count()

        category_stats = db.session.query(
            Report.category,
            func.count(Report.id).label('count')
        ).filter_by(status='verified').group_by(Report.category).all()

        total_revenue = db.session.query(func.sum(DataPurchase.amount)).scalar() or 0
        total_purchases = DataPurchase.query.count()

        return {
            'reports': {
                'total': total_reports,
                'pending': pending_reports,
                'verified': verified_reports,
                'rejected': rejected_reports
            },
            'users': {
                'moderators': total_moderators,
                'researchers': total_researchers
            },
            'categories': [{'category': cat, 'count': count} for cat, count in category_stats],
            'revenue': {
                'total': float(total_revenue),
                'purchases': total_purchases
            }
        }

    except Exception as e:
        logger.error(f"Analytics generation error: {str(e)}")
        return None

def cleanup_expired_downloads() -> int:
    try:
        from models import DataPurchase

        expired_purchases = DataPurchase.query.filter(
            DataPurchase.expires_at < datetime.utcnow()
        ).all()

        for purchase in expired_purchases:
            pass

        logger.info(f"Found {len(expired_purchases)} expired download tokens")
        return len(expired_purchases)

    except Exception as e:
        logger.error(f"Cleanup error: {str(e)}")
        return 0

def backup_database() -> Dict[str, Any]:
    try:
        timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
        backup_filename = f"civicvoice_backup_{timestamp}.sql"

        logger.info(f"Database backup would be created: {backup_filename}")
        return {'success': True, 'filename': backup_filename}

    except Exception as e:
        logger.error(f"Backup error: {str(e)}")
        return {'success': False, 'error': str(e)}