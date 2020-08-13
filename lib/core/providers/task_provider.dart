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
  SharedPreferences mySharedPreferences;
  int get taskCount => _myList.length;
  double taskPercent;
  List<Task> completedTaskList;
  List<Task> uncompletedTaskList;
  List<Task> showingTaskList;
  int currentContainer=0;
  bool gestureCounterLess = false;
  bool gestureCounterMiddle = false;
  bool gestureCounterMore = false;
  Color containerLessColor = Colors.white;
  Color containerMiddleColor = Colors.white;
  Color containerMoreColor = Colors.white;

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

  void editTask({String title, int index,int taskPriority}) {
    _myList[index].taskName = title;
    _myList[index].taskPriority=taskPriority;
    
    setListData();
  }

  void inactivateColor() {
    containerLessColor = Colors.white;
    containerMiddleColor = Colors.white;
    containerMoreColor = Colors.white;
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
}
