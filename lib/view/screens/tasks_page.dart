import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:professional/view/components/widgets/data_search.dart';
import 'package:professional/view/components/widgets/dismissible.dart';
import 'package:professional/view/components/widgets/modal_bottom_sheet.dart';
import 'package:professional/view/components/widgets/percentage_indicator.dart';
import 'package:professional/view/screens/edit_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_task_screen.dart';

class TasksPage extends StatelessWidget {
  var mySharedPreferences;
  var sonuc;
  var deger;

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    TextEditingController editingController = TextEditingController();
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kFieldColor,
              ),
              width: screenSize.width,
              height: screenSize.height * 0.35,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "My",
                                style: TextStyle(
                                  fontFamily: "Russo",
                                  color: Colors.white,
                                  fontSize: 38,
                                ),
                              ),
                              TextSpan(
                                text: "Tasks",
                                style: TextStyle(
                                  fontFamily: "Russo",
                                  color: Colors.white,
                                  fontSize: 38,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            "${taskProvider.taskCount} Tasks",
                            style: TextStyle(
                                color: kFieldColor,
                                fontSize: 28,
                                fontFamily: "Roboto"),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "Completed Tasks:" +
                                    taskProvider.completedTaskList.length
                                        .toString(),
                                style:
                                    TextStyle(color: kFieldColor, fontSize: 16),
                              ),
                              Text(
                                "Left Tasks:" +
                                    taskProvider.uncompletedTaskList.length
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          PercentageIndicator(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          color: kMiniFieldColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            taskProvider.currentContainer = 0;
                            addTask(context, AddTaskScreen());
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.add),
                              Text(
                                "Add Task",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                          
                          controller: taskProvider.textEditingController,
                          onChanged: (value) {
                            taskProvider.taskSearch(value);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(40.0))))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.showingTaskList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  backgroundColor: kBackgroundColor,
                  title: CheckboxListTile(
                    title: Text(
                      taskProvider.showingTaskList[index].taskName,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: kRobotoTextStyle,
                        decoration:
                            taskProvider.showingTaskList[index].taskIsDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    value: taskProvider.showingTaskList[index].taskIsDone,
                    onChanged: (value) {
                      Provider.of<TaskProvider>(context, listen: false)
                          .updateCheckProperty(
                              taskProvider.showingTaskList[index]);
                    },
                  ),
                  /*Text(
                        taskProvider.showingTaskList[index].taskName,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: kRobotoTextStyle,
                          decoration:
                              taskProvider.showingTaskList[index].taskIsDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      Checkbox(
                        value: taskProvider.showingTaskList[index].taskIsDone,
                        onChanged: (value) {
                          Provider.of<TaskProvider>(context, listen: false)
                              .updateCheckProperty(
                                  taskProvider.showingTaskList[index]);
                        },
                      ),*/

                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                visible: taskPriorityNameFunc(context, index) ==
                                        "Unspecified"
                                    ? false
                                    : true,
                                child: Text(
                                  "Task Priority:   " +
                                      taskPriorityNameFunc(context, index),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: kRobotoTextStyle,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Task Due Date:   " +
                                    taskProvider.showingTaskList[index].taskDay
                                        .toString() +
                                    "." +
                                    taskProvider
                                        .showingTaskList[index].taskMonth
                                        .toString() +
                                    "." +
                                    taskProvider.showingTaskList[index].taskYear
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: kRobotoTextStyle,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: kFieldColor,
                                ),
                                onPressed: () {
                                  navigateEditTaskPage(context, index);

                                  taskProvider.activateColor();
                                  editTask(
                                    context,
                                    index,
                                    EditTaskScreen(
                                      index: index,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: kFieldColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            title: Text("Delete ?"),
                                            content: Text(
                                                "Do you want to delete this task?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  taskProvider.getLocalData();
                                                },
                                                child: Text("No"),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  taskProvider.deleteTask(
                                                      taskProvider
                                                              .showingTaskList[
                                                          index]);
                                                  taskProvider
                                                      .taskIsDoneCount();

                                                  Navigator.pop(context);
                                                },
                                                child: Text("Yes"),
                                              ),
                                            ],
                                          ));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void editTask(BuildContext context, int index, Widget child) {
    MyModalBottomSheet myModalBottomSheet = MyModalBottomSheet(
        context: context, index: index, modalBottomSheetChild: child);
    myModalBottomSheet.showModalSheet();
  }

  void addTask(BuildContext context, Widget child) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    taskProvider.inactivateColor();
    taskProvider.taskIsDoneCount();
    MyModalBottomSheet myModalBottomSheet =
        MyModalBottomSheet(context: context, modalBottomSheetChild: child);
    myModalBottomSheet.showModalSheet();
  }

  String taskPriorityNameFunc(BuildContext context, int index) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    if (taskProvider.showingTaskList[index].taskPriority == 1) {
      return "Less";
    }
    if (taskProvider.showingTaskList[index].taskPriority == 2) {
      return "Middle";
    }
    if (taskProvider.showingTaskList[index].taskPriority == 3) {
      return "More";
    }
    if (taskProvider.showingTaskList[index].taskPriority == 0) {
      return "Unspecified";
    }
  }

  void navigateEditTaskPage(BuildContext context, int index) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    taskProvider.inactivateColor();
    taskProvider.currentContainer =
        taskProvider.showingTaskList[index].taskPriority;
    taskProvider.dateYear = taskProvider.showingTaskList[index].taskYear;
    taskProvider.dateMonth = taskProvider.showingTaskList[index].taskMonth;
    taskProvider.dateDay = taskProvider.showingTaskList[index].taskDay;
    taskProvider.date = DateTime.utc(
        taskProvider.dateYear, taskProvider.dateMonth, taskProvider.dateDay);

    taskProvider.activateColor();
  }
}
