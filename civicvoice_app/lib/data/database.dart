import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'civicvoice.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reports (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        latitude REAL,
        longitude REAL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        passwordHash TEXT NOT NULL,
        role TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE verification_logs (
        id TEXT PRIMARY KEY,
        reportId TEXT NOT NULL,
        userId TEXT NOT NULL,
        action TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (reportId) REFERENCES reports (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  Future<int> insertReport(Map<String, dynamic> report) async {
    final db = await database;
    return await db.insert('reports', report);
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final db = await database;
    return await db.query('reports');
  }

  Future<Map<String, dynamic>?> getReport(String id) async {
    final db = await database;
    final result = await db.query(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateReportStatus(String id, String status) async {
    final db = await database;
    return await db.update(
      'reports',
      {'status': status, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertVerificationLog(Map<String, dynamic> log) async {
    final db = await database;
    return await db.insert('verification_logs', log);
  }

  Future<List<Map<String, dynamic>>> getVerificationLogs(String reportId) async {
    final db = await database;
    return await db.query(
      'verification_logs',
      where: 'reportId = ?',
      whereArgs: [reportId],
    );
  }
}