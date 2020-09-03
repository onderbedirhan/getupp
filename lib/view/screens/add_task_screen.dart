import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import '../../core/constants/constants.dart';
import '../../core/models/task_model.dart';
import '../../core/providers/due_date_provider.dart';
import '../../core/providers/task_provider.dart';

class AddTaskScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddTaskScreen();

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    final DueDateProvider dueDateProvider =
        Provider.of<DueDateProvider>(context);

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
            maxLines: null,
            autofocus: true,
            validator: (text) {
              if (text.length < 1) {
                return "Please type the task";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              taskProvider.taskName = value;
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
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: kFieldColor,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          Text(
                            dueDateProvider.dueDateText(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        dueDateProvider.selectDate(context);
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: (dueDateProvider.checkboxDueDateValue),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.red.shade400,
                        child: Row(
                          children: [
                            Icon(
                              Icons.highlight_off,
                              color: Colors.white,
                            ),
                            Text(
                              "Remove Due Date",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          dueDateProvider.dueDateRemove();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: kFieldColor,
              child: Text(
                "Add",
                style: TextStyle(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              onPressed: () {
                addOnPress(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void addOnPress(BuildContext context) async {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    DueDateProvider dueDateProvider =
        Provider.of<DueDateProvider>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Provider.of<TaskProvider>(context, listen: false).addTask(Task(
        taskName: taskProvider.taskName,
        taskPriority: taskProvider.currentContainer,
        taskYear: dueDateProvider.date.year,
        taskMonth: dueDateProvider.date.month,
        taskDay: dueDateProvider.date.day,
        dueDateExist: dueDateProvider.checkboxDueDateValue,
      ));
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
      Provider.of<TaskProvider>(context, listen: false).inactivateColor();
      taskProvider.currentContainer = 0;
    }
  }
}
