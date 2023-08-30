class Task {

  Task({required this.task, required this.date});

  Task.fromJson(Map<String, dynamic> json)
      : task = json['title'],
        date = json ['date'];

  String task;
  String date;

  Map<String, dynamic> toJson() {
    return {
      'title': task,
      'date': date,
    };
  }
}