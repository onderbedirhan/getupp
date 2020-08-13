import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String taskName;
  bool taskIsDone ;
  int taskPriority;

  void changeTaskIsDone() {
    taskIsDone = !taskIsDone;
  }

  Task({this.taskName, this.taskIsDone=false,this.taskPriority});

  factory Task.fromJson(Map<String, dynamic> json) {
    //taskName = json["taskName"];
    //taskIsDone = json["taskIsDone"];
    return Task(
      taskName:json["taskName"],
      taskIsDone: json["taskIsDone"],
      taskPriority: json["taskPriority"],
    );
  }

  Map<String, dynamic> toJson() => {
        "taskName": taskName,
        "taskIsDone": taskIsDone,
        "taskPriority":taskPriority,
      };
}
