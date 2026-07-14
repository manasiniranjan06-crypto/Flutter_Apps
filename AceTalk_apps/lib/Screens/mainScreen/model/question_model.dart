// class QuestionModel {
//   final String question;
//   final String level;
//   //final String correctAnswer;
//   final List<String> keywords;


  
//   QuestionModel({
//     required this.level, 
//     required this.question,
//     //required this.correctAnswer,
//     required this.keywords
//     });

    
// }
// lib/features/interview/domain/entities/question_entity.dart

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