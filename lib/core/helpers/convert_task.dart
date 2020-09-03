import '../../core/models/task_model.dart';

class ConvertTask {
  final List<Task> taskList;

  ConvertTask(this.taskList);
  factory ConvertTask.fromJson(List<dynamic> list) {
    List<Task> taskList = List<Task>();
    taskList = list.map((i) => Task.fromJson(i)).toList();
    return ConvertTask(taskList);
  }
}
