from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.String(36), primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    role = db.Column(db.String(20), nullable=False)
    organization = db.Column(db.String(200))
    email_verified = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    last_login = db.Column(db.DateTime)

    verification_logs = db.relationship('VerificationLog', backref='user', lazy=True)
    data_purchases = db.relationship('DataPurchase', backref='user', lazy=True)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def to_dict(self):
        return {
            'id': self.id,
            'email': self.email,
            'role': self.role,
            'organization': self.organization,
            'email_verified': self.email_verified,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'last_login': self.last_login.isoformat() if self.last_login else None
        }

class Report(db.Model):
    __tablename__ = 'reports'

    id = db.Column(db.String(36), primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    description = db.Column(db.Text)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    status = db.Column(db.String(20), default='pending')
    language = db.Column(db.String(2), default='en')
    reference_code = db.Column(db.String(20), unique=True, nullable=False)
    passphrase = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    verification_logs = db.relationship('VerificationLog', backref='report', lazy=True)
    attachments = db.relationship('ReportAttachment', backref='report', lazy=True, cascade='all, delete-orphan')

    def to_dict(self, include_sensitive=False):
        data = {
            'id': self.id,
            'title': self.title,
            'category': self.category,
            'description': self.description,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'status': self.status,
            'language': self.language,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }

        if include_sensitive:
            data.update({
                'reference_code': self.reference_code,
                'passphrase': self.passphrase
            })

        return data

class ReportAttachment(db.Model):
    __tablename__ = 'report_attachments'

    id = db.Column(db.String(36), primary_key=True)
    report_id = db.Column(db.String(36), db.ForeignKey('reports.id'), nullable=False)
    filename = db.Column(db.String(255), nullable=False)
    file_path = db.Column(db.String(500), nullable=False)
    file_size = db.Column(db.Integer, nullable=False)
    content_type = db.Column(db.String(100), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'filename': self.filename,
            'file_size': self.file_size,
            'content_type': self.content_type,
            'created_at': self.created_at.isoformat()
        }

class VerificationLog(db.Model):
    __tablename__ = 'verification_logs'

    id = db.Column(db.String(36), primary_key=True)
    report_id = db.Column(db.String(36), db.ForeignKey('reports.id'), nullable=False)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    action = db.Column(db.String(20), nullable=False)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'report_id': self.report_id,
            'user_id': self.user_id,
            'action': self.action,
            'notes': self.notes,
            'created_at': self.created_at.isoformat()
        }

class DataPurchase(db.Model):
    __tablename__ = 'data_purchases'

    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False)
    stripe_payment_intent_id = db.Column(db.String(100), unique=True, nullable=False)
    amount = db.Column(db.Float, nullable=False)
    report_count = db.Column(db.Integer, nullable=False)
    filters = db.Column(db.Text)
    status = db.Column(db.String(20), default='completed')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    expires_at = db.Column(db.DateTime, nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'amount': self.amount,
            'report_count': self.report_count,
            'status': self.status,
            'created_at': self.created_at.isoformat(),
            'expires_at': self.expires_at.isoformat()
        }

class SystemSettings(db.Model):
    __tablename__ = 'system_settings'

    id = db.Column(db.String(36), primary_key=True)
    key = db.Column(db.String(100), unique=True, nullable=False)
    value = db.Column(db.Text, nullable=False)
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'key': self.key,
            'value': self.value,
            'description': self.description,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }

db.Index('idx_reports_status', Report.status)
db.Index('idx_reports_category', Report.category)
db.Index('idx_reports_created_at', Report.created_at)
db.Index('idx_reports_reference_code', Report.reference_code)
db.Index('idx_users_email', User.email)
db.Index('idx_users_role', User.role)
db.Index('idx_verification_logs_report_id', VerificationLog.report_id)
db.Index('idx_data_purchases_user_id', DataPurchase.user_id)
db.Index('idx_data_purchases_expires_at', DataPurchase.expires_at)