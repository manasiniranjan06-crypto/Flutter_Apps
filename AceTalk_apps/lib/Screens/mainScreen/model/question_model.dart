

class QuestionEntity {
  final String question;
  final String level; // Beginner | Easy | Medium | Hard
  final List<String> keywords;

  const QuestionEntity({
    required this.question,
    required this.level,
    required this.keywords,
  });
}