import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/helpers/convert_task.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _myList = [];
  List<Task> recentTasks = [];
  List<Task> suggestionList = [];
  SharedPreferences mySharedPreferences;
  int get taskCount => _myList.length;
  DateTime date = DateTime.utc(2020, 4, 19);
  int dateYear;
  int dateMonth;
  int dateDay;
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
  TextEditingController textEditingController=TextEditingController();

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

  void editTask({String title, Task task, int taskPriority}) {
    _myList[_myList.indexOf(task)].taskName = title;
    _myList[_myList.indexOf(task)].taskPriority = taskPriority;
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
        completedTaskList.add(value);
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
      showingTaskList.add(task);
    }
    _myList = showingTaskList;
  }

  void getLocalData() async {
    mySharedPreferences = await SharedPreferences.getInstance();
    var sonuc = mySharedPreferences.getString("taskList");
    if (sonuc != null) {
      final deger = json.decode(sonuc);
      ConvertTask convertTask = ConvertTask.fromJson(deger);
      _myList = convertTask.taskList;
      taskIsDoneCount();
      notifyListeners();
    }
  }
  void removeQuery(){
    textEditingController.clear();
    notifyListeners();
  }

  Future<Null> selectDate(BuildContext context) async {
    DateTime datePicker = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (datePicker != null && datePicker != date) {
      date = datePicker;
      dateYear = date.year;
      dateMonth = date.month;
      dateDay = date.day;
      notifyListeners();
    }
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
            .where((p) => p.taskName.toLowerCase().startsWith(query))
            .toList();
    showingTaskList = suggestionList;
    setListData();
  }
}
