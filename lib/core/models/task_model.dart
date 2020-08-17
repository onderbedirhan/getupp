
class Task {
  String taskName;
  bool taskIsDone;
  int taskPriority;
  int taskYear;
  int taskMonth;
  int taskDay;
  bool dueDateExist;

  void changeTaskIsDone() {
    taskIsDone = !taskIsDone;
  }

  Task(
      {this.taskName,
      this.taskIsDone = false,
      this.taskPriority,
      this.taskYear,
      this.taskMonth,
      this.taskDay,
      this.dueDateExist});

  factory Task.fromJson(Map<String, dynamic> json) {
    //taskName = json["taskName"];
    //taskIsDone = json["taskIsDone"];
    return Task(
        taskName: json["taskName"],
        taskIsDone: json["taskIsDone"],
        taskPriority: json["taskPriority"],
        taskYear: json["taskYear"],
        taskMonth: json["taskMonth"],
        taskDay: json["taskDay"],
        dueDateExist: json["dueDateExist"]);
  }

  Map<String, dynamic> toJson() => {
        "taskName": taskName,
        "taskIsDone": taskIsDone,
        "taskPriority": taskPriority,
        "taskYear": taskYear,
        "taskMonth": taskMonth,
        "taskDay": taskDay,
        "dueDateExist": dueDateExist,
      };
}
