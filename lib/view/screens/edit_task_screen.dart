import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatelessWidget {
  String taskName = "";
  var formKey = GlobalKey<FormState>();
  

  int index;
  EditTaskScreen({this.index});
  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    
    
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Text("Edit Task",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: kRobotoTextStyle,
                  color: kFieldColor)),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: taskProvider.myList[index].taskName,
            validator: (text) {
              if (text.length < 1) {
                return "Please type the task";
              } else {
                return null;
              }
            },
            autofocus: true,
            onSaved: (value) {
              taskName = value;
            },
            decoration: InputDecoration(
              labelText: "Edit Task Name",
              hintText:
                  Provider.of<TaskProvider>(context).myList[index].taskName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text("Task Priority",
                  style: TextStyle(fontSize: 20, fontFamily: kRobotoTextStyle)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  taskProvider.gestureCounterLess =
                      !taskProvider.gestureCounterLess;
                  if (taskProvider.gestureCounterLess) {
                    taskProvider.currentContainer = 1;
                  } else {
                    taskProvider.currentContainer = 0;
                  }
                  print(taskProvider.currentContainer);
                  taskProvider.gestureFunc();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(),
                    color: taskProvider.containerLessColor,
                  ),
                  child: Text("Less"),
                  width: 90,
                  height: 50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  taskProvider.gestureCounterMiddle =
                      !taskProvider.gestureCounterMiddle;
                  if (taskProvider.gestureCounterMiddle) {
                    taskProvider.currentContainer = 2;
                  } else {
                    taskProvider.currentContainer = 0;
                  }
                  print(taskProvider.currentContainer);
                  taskProvider.gestureFunc();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(),
                    color: taskProvider.containerMiddleColor,
                  ),
                  child: Text("Middle"),
                  width: 90,
                  height: 50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  taskProvider.gestureCounterMore =
                      !taskProvider.gestureCounterMore;
                  if (taskProvider.gestureCounterMore) {
                    taskProvider.currentContainer = 3;
                  } else {
                    taskProvider.currentContainer = 0;
                  }
                  print(taskProvider.currentContainer);
                  taskProvider.gestureFunc();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(),
                    color: taskProvider.containerMoreColor,
                  ),
                  child: Text("More"),
                  width: 90,
                  height: 50,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  color: kMiniFieldColor,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Text(
                        "  Due Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: () {
                    taskProvider.selectDate(context);
                  },
                ),
                RaisedButton(
                  color: kFieldColor,
                  child: Text(
                    "Edit",
                    style: TextStyle(color: kBackgroundColor),
                  ),
                  onPressed: () {
                    editOnPress(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void editOnPress(BuildContext context) async {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Provider.of<TaskProvider>(context, listen: false).editTask(
          title: taskName,
          index: index,
          taskPriority: taskProvider.currentContainer);
      taskProvider.editTaskDueDate(
        index: index,
        year: taskProvider.dateYear,
        month: taskProvider.dateMonth,
        day: taskProvider.dateDay,
      );
      taskProvider.taskIsDoneCount();
      taskProvider.currentContainer = 0;
      Navigator.pop(context);
    }
  }
}
