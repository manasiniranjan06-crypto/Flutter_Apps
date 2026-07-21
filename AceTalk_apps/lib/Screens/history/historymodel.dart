// lib/features/history/domain/entities/session_entity.dart

class SessionEntity {
  final int? id;
  final String language;
  final String level;
  final String round;
  final int totalQuestions;
  final int correctAnswers;
  final double scorePercent;
  final DateTime completedAt;
  final List<QuestionResultEntity> results;

  const SessionEntity({
    this.id,
    required this.language,
    required this.level,
    required this.round,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.scorePercent,
    required this.completedAt,
    required this.results,
  });

  String get grade {
    if (scorePercent >= 90) return 'A+';
    if (scorePercent >= 80) return 'A';
    if (scorePercent >= 70) return 'B';
    if (scorePercent >= 60) return 'C';
    return 'D';
  }
}

class QuestionResultEntity {
  final String question;
  final String userAnswer;
  final bool isCorrect;
  final int timeTaken; // seconds

  const QuestionResultEntity({
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
    required this.timeTaken,
  });
}