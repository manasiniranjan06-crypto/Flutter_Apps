import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class ProfileSqflite {
  ProfileSqflite._();
  static final ProfileSqflite instance = ProfileSqflite._();
  static Database? _db;

  Future<Database> _getDb() async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'Profile.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE PROFILEDATA (
            id         INTEGER PRIMARY KEY,
            name       TEXT,
            email      TEXT,
            phoneNo    TEXT,
            location   TEXT,
            skill      TEXT,
            targetRole TEXT,
            experience TEXT,
            education  TEXT,
            imagepath  TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await _getDb();
    final rows = await db.query('PROFILEDATA', where: 'id = ?', whereArgs: [1]);
    return rows.isNotEmpty ? Map<String, dynamic>.from(rows.first) : null;
  }

  Future<void> saveProfile(Map<String, dynamic> data) async {
    final db = await _getDb();
    await db.insert('PROFILEDATA', {
      ...data,
      'id': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProfile() async {
    final db = await _getDb();
    await db.delete('PROFILEDATA', where: 'id = ?', whereArgs: [1]);
  }
}