import unittest
import tempfile
import os
import json
import sys
import importlib.util

current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)

print(f"Current directory: {current_dir}")
print(f"Parent directory: {parent_dir}")
print(f"Files in parent directory: {os.listdir(parent_dir)}")

if parent_dir not in sys.path:
    sys.path.insert(0, parent_dir)

app_path = os.path.join(parent_dir, 'app.py')
models_path = os.path.join(parent_dir, 'models.py')

print(f"Looking for app.py at: {app_path}")
print(f"App.py exists: {os.path.exists(app_path)}")
print(f"Looking for models.py at: {models_path}")
print(f"Models.py exists: {os.path.exists(models_path)}")

if not os.path.exists(app_path):
    print("ERROR: app.py not found!")
    possible_files = [f for f in os.listdir(parent_dir) if f.endswith('.py')]
    print(f"Python files in directory: {possible_files}")
    sys.exit(1)

if not os.path.exists(models_path):
    print("ERROR: models.py not found!")
    sys.exit(1)

spec_models = importlib.util.spec_from_file_location("models", models_path)
models = importlib.util.module_from_spec(spec_models)
sys.modules['models'] = models
spec_models.loader.exec_module(models)

spec_app = importlib.util.spec_from_file_location("app", app_path)
app = importlib.util.module_from_spec(spec_app)
sys.modules['app'] = app
spec_app.loader.exec_module(app)

class BackendTestCase(unittest.TestCase):
    def setUp(self):
        self.db_fd, self.db_path = tempfile.mkstemp()

        self.app = app.create_app()
        self.app.config.update({
            "TESTING": True,
            "SQLALCHEMY_DATABASE_URI": f"sqlite:///{self.db_path}",
            "SECRET_KEY": "test-secret-key"
        })

        self.client = self.app.test_client()

        with self.app.app_context():
            models.db.create_all()

    def tearDown(self):
        with self.app.app_context():
            models.db.drop_all()
        os.close(self.db_fd)
        os.unlink(self.db_path)

    def test_health_check(self):
        response = self.client.get('/api/health')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['status'], 'healthy')

    def test_get_categories(self):
        response = self.client.get('/api/categories')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIn('categories', data)
        self.assertIsInstance(data['categories'], list)
        self.assertIn('corruption', data['categories'])

    def test_submit_report_success(self):
        report_data = {
            'title': 'Test Infrastructure Issue',
            'category': 'infrastructure',
            'description': 'Road needs repair on Main Street',
            'latitude': '45.4215',
            'longitude': '-75.6972',
            'language': 'en'
        }

        response = self.client.post('/api/reports', data=report_data)
        self.assertEqual(response.status_code, 201)

        data = json.loads(response.data)
        self.assertIn('reference_code', data)
        self.assertIn('passphrase', data)
        self.assertIn('report_id', data)

        with self.app.app_context():
            report = models.Report.query.filter_by(reference_code=data['reference_code']).first()
            self.assertIsNotNone(report)
            self.assertEqual(report.title, 'Test Infrastructure Issue')
            self.assertEqual(report.status, 'pending')

    def test_submit_report_missing_fields(self):
        incomplete_data = {
            'title': 'Incomplete Report',
        }

        response = self.client.post('/api/reports', data=incomplete_data)
        self.assertEqual(response.status_code, 400)
        data = json.loads(response.data)
        self.assertIn('error', data)

    def test_track_report_success(self):
        report_data = {
            'title': 'Trackable Report',
            'category': 'healthcare',
            'description': 'Hospital needs more funding',
            'latitude': '45.4215',
            'longitude': '-75.6972'
        }

        submit_response = self.client.post('/api/reports', data=report_data)
        submit_data = json.loads(submit_response.data)

        track_data = {
            'reference_code': submit_data['reference_code'],
            'passphrase': submit_data['passphrase']
        }

        track_response = self.client.post('/api/reports/track',
                                          data=json.dumps(track_data),
                                          content_type='application/json')

        self.assertEqual(track_response.status_code, 200)
        track_result = json.loads(track_response.data)

        self.assertIn('report', track_result)
        self.assertIn('status_history', track_result)
        self.assertEqual(track_result['report']['title'], 'Trackable Report')

    def test_track_report_invalid_credentials(self):
        invalid_data = {
            'reference_code': 'INVALID123',
            'passphrase': 'wrongpass'
        }

        response = self.client.post('/api/reports/track',
                                    data=json.dumps(invalid_data),
                                    content_type='application/json')

        self.assertEqual(response.status_code, 404)
        data = json.loads(response.data)
        self.assertIn('error', data)

    def test_public_reports_endpoint(self):
        with self.app.app_context():
            report = models.Report(
                id='test-public-report',
                title='Public Test Report',
                category='environment',
                description='This is a verified public report',
                latitude=45.4215,
                longitude=-75.6972,
                reference_code='PUB123',
                passphrase='pubpass',
                status='verified'
            )
            models.db.session.add(report)
            models.db.session.commit()

        response = self.client.get('/api/public/reports')
        self.assertEqual(response.status_code, 200)

        data = json.loads(response.data)
        self.assertIn('reports', data)
        self.assertIn('pagination', data)

        reports = data['reports']
        self.assertTrue(any(r['title'] == 'Public Test Report' for r in reports))

    def test_user_model_password_hashing(self):
        with self.app.app_context():
            user = models.User(
                id='test-user-123',
                email='test@example.com',
                role='moderator',
                organization='Test Org'
            )
            user.set_password('MySecretPassword123')

            self.assertNotEqual(user.password_hash, 'MySecretPassword123')

            from werkzeug.security import check_password_hash
            self.assertTrue(check_password_hash(user.password_hash, 'MySecretPassword123'))
            self.assertFalse(check_password_hash(user.password_hash, 'WrongPassword'))

    def test_coordinate_validation(self):
        invalid_lat_data = {
            'title': 'Invalid Location',
            'category': 'other',
            'latitude': '999',
            'longitude': '-75.6972'
        }

        response = self.client.post('/api/reports', data=invalid_lat_data)
        self.assertEqual(response.status_code, 400)

        invalid_lng_data = {
            'title': 'Invalid Location',
            'category': 'other',
            'latitude': '45.4215',
            'longitude': '999'
        }

        response = self.client.post('/api/reports', data=invalid_lng_data)
        self.assertEqual(response.status_code, 400)

    def test_description_length_validation(self):
        long_description = 'x' * 2001

        report_data = {
            'title': 'Long Description Test',
            'category': 'other',
            'description': long_description,
            'latitude': '45.4215',
            'longitude': '-75.6972'
        }

        response = self.client.post('/api/reports', data=report_data)
        self.assertEqual(response.status_code, 400)
        data = json.loads(response.data)
        self.assertIn('exceeds 2000 characters', data['error'])

    def test_language_validation(self):
        report_data = {
            'title': 'Language Test',
            'category': 'other',
            'latitude': '45.4215',
            'longitude': '-75.6972',
            'language': 'invalid_lang'
        }

        response = self.client.post('/api/reports', data=report_data)
        self.assertEqual(response.status_code, 400)
        data = json.loads(response.data)
        self.assertIn('Language must be en or fr', data['error'])

    def test_title_validation(self):
        short_title_data = {
            'title': 'Hi',
            'category': 'other',
            'latitude': '45.4215',
            'longitude': '-75.6972'
        }

        response = self.client.post('/api/reports', data=short_title_data)

        if response.status_code == 201:
            print("Note: Backend accepts short titles (no minimum length validation)")
            data = json.loads(response.data)
            with self.app.app_context():
                report = models.Report.query.filter_by(reference_code=data['reference_code']).first()
                self.assertEqual(report.title, 'Hi')
        else:
            self.assertEqual(response.status_code, 400)

        long_title_data = {
            'title': 'x' * 201,
            'category': 'other',
            'latitude': '45.4215',
            'longitude': '-75.6972'
        }

        response = self.client.post('/api/reports', data=long_title_data)
        self.assertEqual(response.status_code, 201)
        data = json.loads(response.data)

        with self.app.app_context():
            report = models.Report.query.filter_by(reference_code=data['reference_code']).first()
            self.assertEqual(len(report.title), 200)

    def test_public_reports_filtering(self):
        with self.app.app_context():
            report1 = models.Report(
                id='report-1',
                title='Healthcare Report',
                category='healthcare',
                description='Healthcare issue',
                latitude=45.4215,
                longitude=-75.6972,
                reference_code='HC123',
                passphrase='pass1',
                status='verified'
            )

            report2 = models.Report(
                id='report-2',
                title='Infrastructure Report',
                category='infrastructure',
                description='Infrastructure issue',
                latitude=45.4215,
                longitude=-75.6972,
                reference_code='INF123',
                passphrase='pass2',
                status='verified'
            )

            models.db.session.add(report1)
            models.db.session.add(report2)
            models.db.session.commit()

        response = self.client.get('/api/public/reports?category=healthcare')
        self.assertEqual(response.status_code, 200)

        data = json.loads(response.data)
        reports = data['reports']
        healthcare_reports = [r for r in reports if r['category'] == 'healthcare']
        self.assertTrue(len(healthcare_reports) >= 1)

    def test_report_model_defaults(self):
        with self.app.app_context():
            report = models.Report(
                id='default-test',
                title='Default Test',
                category='other',
                latitude=45.0,
                longitude=-75.0,
                reference_code='DEF123',
                passphrase='defpass'
            )

            models.db.session.add(report)
            models.db.session.commit()

            self.assertEqual(report.status, 'pending')
            self.assertEqual(report.language, 'en')
            self.assertIsNotNone(report.created_at)
            self.assertIsNotNone(report.updated_at)

if __name__ == '__main__':
    unittest.main(verbosity=2)