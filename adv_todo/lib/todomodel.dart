class TodoModel {
  String title;
  String description;
  String date;
  int Id;

  TodoModel({
    required this.title,
    required this.description,
    required this.date,
    this.Id = 0,
  });
}
