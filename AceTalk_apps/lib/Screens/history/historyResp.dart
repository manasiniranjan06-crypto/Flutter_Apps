// lib/features/history/data/repositories/session_repository_impl.dart
import 'package:ai_interview_app/Screens/history/database.dart';
import 'package:ai_interview_app/Screens/history/historymodel.dart';
import 'package:ai_interview_app/Screens/history/historyse.dart';
import 'package:sqflite/sqflite.dart';

abstract class SessionRepository {
  Future<int> saveSession(SessionEntity session);
  Future<List<SessionEntity>> getAllSessions();
  Future<void> deleteSession(int id);
  Future<void> clearAll();
}

class SessionRepositoryImpl implements SessionRepository {
  final AppDatabase _db;
  SessionRepositoryImpl({AppDatabase? db}) : _db = db ?? AppDatabase.instance;

  @override
  Future<int> saveSession(SessionEntity session) async {
    final db = await _db.database;

    return db.transaction<int>((txn) async {
      final sessionId = await txn.insert(
        'sessions',
        SessionModel.fromEntity(session).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (final result in session.results) {
        await txn.insert(
          'question_results',
          QuestionResultModel.fromEntity(result).toMap(sessionId),
        );
      }
      return sessionId;
    });
  }

  @override
  Future<List<SessionEntity>> getAllSessions() async {
    final db = await _db.database;
    final sessionMaps = await db.query(
      'sessions',
      orderBy: 'completed_at DESC',
    );

    final List<SessionEntity> sessions = [];
    for (final map in sessionMaps) {
      final id = map['id'] as int;
      final resultMaps = await db.query(
        'question_results',
        where: 'session_id = ?',
        whereArgs: [id],
      );
      final results = resultMaps
          .map((r) => QuestionResultModel.fromMap(r))
          .toList();
      sessions.add(SessionModel.fromMap(map, results));
    }
    return sessions;
  }

  @override
  Future<void> deleteSession(int id) async {
    final db = await _db.database;
    await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> clearAll() async {
    final db = await _db.database;
    await db.delete('sessions');
  }
}