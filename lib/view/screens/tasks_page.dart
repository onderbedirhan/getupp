import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
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
    var taskProvider = Provider.of<TaskProvider>(context);
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: kBackgroundColor,
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
              height: screenSize.height * 0.30,
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
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
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
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.showingTaskList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyDismissibleWidget(
                      index: index,
                      onDismissed: (direction) {
                        
                        if (direction == DismissDirection.endToStart) {
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
                                              taskProvider.myList[index]);
                                          taskProvider.taskIsDoneCount();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  ));
                        } else if (direction == DismissDirection.startToEnd) {
                          editTask(
                              context,
                              index,
                              EditTaskScreen(
                                index: index,
                              ));
                        }
                      },
                      dismissibleChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            child: Text(taskProvider
                                .showingTaskList[index].taskPriority
                                .toString()),
                          ),
                          Text(
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
                            value:
                                taskProvider.showingTaskList[index].taskIsDone,
                            onChanged: (value) {
                              Provider.of<TaskProvider>(context, listen: false)
                                  .updateCheckProperty(
                                      taskProvider.showingTaskList[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.inactivateColor();
    taskProvider.taskIsDoneCount();
    MyModalBottomSheet myModalBottomSheet =
        MyModalBottomSheet(context: context, modalBottomSheetChild: child);
    myModalBottomSheet.showModalSheet();
  }


}
