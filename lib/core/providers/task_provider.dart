import 'package:flutter/material.dart';
import 'dart:collection' show UnmodifiableListView;
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import '../../core/constants/constants.dart';
import '../../core/helpers/convert_task.dart';
import '../../core/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  String taskName;
  List<Task> _myList = [];
  List<Task> recentTasks = [];
  List<Task> suggestionList = [];
  SharedPreferences mySharedPreferences;
  int get taskCount => _myList.length;
  double taskPercent;
  String textFieldquery = "";
  List<Task> completedTaskList;
  List<Task> uncompletedTaskList;
  List<Task> showingTaskList;
  int currentContainer = 0;
  bool gestureCounterLess = false;
  bool gestureCounterMiddle = false;
  bool gestureCounterMore = false;
  Color containerLessColor = Colors.white;
  Color containerMiddleColor = Colors.white;
  Color containerMoreColor = Colors.white;
  bool isHideCompletedTask = false;

  TextEditingController textEditingController = TextEditingController();

  UnmodifiableListView<Task> get myList => UnmodifiableListView(_myList);

  TaskProvider() {
    getLocalData();
    taskIsDoneCount();
  }
  void setListData() {
    mySharedPreferences.setString("taskList", json.encode(_myList));
    notifyListeners();
  }

  void addTask(Task newTask) {
    _myList.insert(0, newTask);
    setListData();
    taskIsDoneCount();
  }

  void deleteTask(Task currentTask) {
    _myList.remove(currentTask);
    setListData();
  }

  void updateCheckProperty(Task currentTask) {
    currentTask.changeTaskIsDone();
    setListData();
    taskIsDoneCount();
  }

  void editTask(
      {String title, Task task, int taskPriority, bool checkboxDueDateValue}) {
    _myList[_myList.indexOf(task)].taskName = title;
    _myList[_myList.indexOf(task)].taskPriority = taskPriority;
    _myList[_myList.indexOf(task)].dueDateExist = checkboxDueDateValue;
    setListData();
  }

  void editTaskDueDate({Task task, int year, int month, int day}) {
    _myList[_myList.indexOf(task)].taskYear = year;
    _myList[_myList.indexOf(task)].taskMonth = month;
    _myList[_myList.indexOf(task)].taskDay = day;
    setListData();
  }

  void inactivateColor() {
    containerLessColor = Colors.white;
    containerMiddleColor = Colors.white;
    containerMoreColor = Colors.white;
    notifyListeners();
  }

  void activateColor() {
    if (currentContainer == 1) {
      containerLessColor = kMiniFieldColor;
    }
    if (currentContainer == 2) {
      containerMiddleColor = kMiniFieldColor;
    }
    if (currentContainer == 3) {
      containerMoreColor = kMiniFieldColor;
    }
    if (currentContainer == 0) {
      containerLessColor = Colors.white;
      containerMiddleColor = Colors.white;
      containerMoreColor = Colors.white;
    }
    notifyListeners();
  }

  void gestureFunc() {
    containerLessColor = Colors.white;
    containerMiddleColor = Colors.white;
    containerMoreColor = Colors.white;
    if (currentContainer == 1) {
      containerLessColor = kMiniFieldColor;
      gestureCounterMiddle = false;
      gestureCounterMore = false;
    }
    if (currentContainer == 2) {
      containerMiddleColor = kMiniFieldColor;
      gestureCounterLess = false;
      gestureCounterMore = false;
    }
    if (currentContainer == 3) {
      containerMoreColor = kMiniFieldColor;
      gestureCounterLess = false;
      gestureCounterMiddle = false;
    }
    if (currentContainer == 0) {
      gestureCounterLess = false;
      gestureCounterMiddle = false;
      gestureCounterMore = false;
      containerLessColor = Colors.white;
      containerMiddleColor = Colors.white;
      containerMoreColor = Colors.white;
    }
    notifyListeners();
  }

  void taskIsDoneCount() {
    completedTaskList = [];
    uncompletedTaskList = [];
    showingTaskList = [];
    for (Task value in _myList) {
      if (value.taskIsDone == true) {
        if (!isHideCompletedTask) {
          completedTaskList.add(value);
        }
      } else {
        uncompletedTaskList.add(value);
      }
    }
    uncompletedTaskList
        .sort((a, b) => b.taskPriority.compareTo(a.taskPriority));

    taskPercent = completedTaskList.length / _myList.length;
    if (taskPercent.isNaN) {
      taskPercent = 0;
    }
    for (Task task in uncompletedTaskList) {
      showingTaskList.add(task);
    }
    for (Task task in completedTaskList) {
      if (!isHideCompletedTask) {
        showingTaskList.add(task);
      }
    }
    _myList = showingTaskList;
  }

  void getLocalData() async {
    mySharedPreferences = await SharedPreferences.getInstance();
    String result = mySharedPreferences.getString("taskList");
    if (result != null) {
      final value = json.decode(result);
      ConvertTask convertTask = ConvertTask.fromJson(value);
      _myList = convertTask.taskList;
      taskIsDoneCount();
      notifyListeners();
    }
  }

  void removeQuery() {
    textEditingController.clear();
    notifyListeners();
  }

  void taskSearch(String query) {
    if (query != null) {
      textFieldquery = query;
    } else {
      textFieldquery = "";
    }
    suggestionList = query.isEmpty
        ? _myList
        : _myList
            .where((p) => p.taskName.toLowerCase().contains(query))
            .toList();
    showingTaskList = suggestionList;
    setListData();
  }
}
