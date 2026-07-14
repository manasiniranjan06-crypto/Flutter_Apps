


class InterviewModel {
  int? Id;
  String language;
  int score;
  int totalQuestion;
  String date;

  InterviewModel({
    this.Id ,
   required this.date,
   required this.score,
   required this.totalQuestion,
   required this.language,
  });

  // Map<String, dynamic> tomap(){
  //   return {
  //     'Id':Id,
  //     'language':language,
  //     'score':score,
  //     'totalQuestion':totalQuestion,
  //     'date':date
  //   };
  // } 

}