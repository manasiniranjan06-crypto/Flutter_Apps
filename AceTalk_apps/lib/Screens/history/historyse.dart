// lib/features/history/data/models/session_model.dart
import 'package:ai_interview_app/Screens/history/historymodel.dart';

//import '../../domain/entities/session_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    super.id,
    required super.language,
    required super.level,
    required super.round,
    required super.totalQuestions,
    required super.correctAnswers,
    required super.scorePercent,
    required super.completedAt,
    required super.results,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'language': language,
      'level': level,
      'round': round,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'score_percent': scorePercent,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  factory SessionModel.fromMap(
    Map<String, dynamic> map,
    List<QuestionResultModel> results,
  ) {
    return SessionModel(
      id: map['id'] as int?,
      language: map['language'] as String,
      level: map['level'] as String,
      round: map['round'] as String,
      totalQuestions: map['total_questions'] as int,
      correctAnswers: map['correct_answers'] as int,
      scorePercent: (map['score_percent'] as num).toDouble(),
      completedAt: DateTime.parse(map['completed_at'] as String),
      results: results,
    );
  }

  factory SessionModel.fromEntity(SessionEntity entity) {
    return SessionModel(
      id: entity.id,
      language: entity.language,
      level: entity.level,
      round: entity.round,
      totalQuestions: entity.totalQuestions,
      correctAnswers: entity.correctAnswers,
      scorePercent: entity.scorePercent,
      completedAt: entity.completedAt,
      results: entity.results,
    );
  }
}

class QuestionResultModel extends QuestionResultEntity {
  const QuestionResultModel({
    required super.question,
    required super.userAnswer,
    required super.isCorrect,
    required super.timeTaken,
  });

  Map<String, dynamic> toMap(int sessionId) {
    return {
      'session_id': sessionId,
      'question': question,
      'user_answer': userAnswer,
      'is_correct': isCorrect ? 1 : 0,
      'time_taken': timeTaken,
    };
  }

  factory QuestionResultModel.fromMap(Map<String, dynamic> map) {
    return QuestionResultModel(
      question: map['question'] as String,
      userAnswer: map['user_answer'] as String,
      isCorrect: (map['is_correct'] as int) == 1,
      timeTaken: map['time_taken'] as int,
    );
  }

  factory QuestionResultModel.fromEntity(QuestionResultEntity e) {
    return QuestionResultModel(
      question: e.question,
      userAnswer: e.userAnswer,
      isCorrect: e.isCorrect,
      timeTaken: e.timeTaken,
    );
  }
}