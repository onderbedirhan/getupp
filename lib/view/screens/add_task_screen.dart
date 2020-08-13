import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/task_provider.dart';

import 'package:provider/provider.dart';

class AddTaskScreen extends StatelessWidget {
  String taskName = "";
  var formKey = GlobalKey<FormState>();
  AddTaskScreen();
  
  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Text("Add Task",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: kRobotoTextStyle,
                  fontWeight: FontWeight.bold,
                  color: kFieldColor)),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            autofocus: true,
            validator: (text) {
              if (text.length < 1) {
                return "Please type the task";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              taskName = value;
            },
            decoration: InputDecoration(
              labelText: "Task Name",
              hintText: "Please type the task name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  taskProvider.gestureCounterLess=!taskProvider.gestureCounterLess;
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
                  taskProvider.gestureCounterMiddle=!taskProvider.gestureCounterMiddle;
                  if (taskProvider.gestureCounterMiddle ) {
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
                  taskProvider.gestureCounterMore=!taskProvider.gestureCounterMore;
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: kFieldColor,
                  child: Text(
                    "Add",
                    style: TextStyle(color: kBackgroundColor),
                  ),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      Provider.of<TaskProvider>(context, listen: false)
                          .addTask(Task(taskName: taskName,taskPriority: taskProvider.currentContainer));
                      Navigator.pop(context);
                      Provider.of<TaskProvider>(context, listen: false).inactivateColor();
                      taskProvider.currentContainer=0;
                      
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
