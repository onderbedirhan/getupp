import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/providers/due_date_provider.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:professional/view/components/widgets/modal_bottom_sheet.dart';
import 'package:professional/view/components/widgets/percentage_indicator.dart';
import 'package:professional/view/components/widgets/snackbar.dart';
import 'package:professional/view/screens/edit_task_screen.dart';
import 'package:provider/provider.dart';
import 'add_task_screen.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    final DueDateProvider dueDateProvider =
        Provider.of<DueDateProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;

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
                    SizedBox(
                      height: 5,
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
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.red.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            taskProvider.currentContainer = 0;
                            dueDateProvider.checkboxDueDateValue = false;
                            addTask(context, AddTaskScreen());
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                "Add Task",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
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
                  leading: priorityIcon(context, index),
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          taskProvider.showingTaskList[index].taskName,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: kRobotoTextStyle,
                            decoration:
                                taskProvider.showingTaskList[index].taskIsDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: taskProvider.showingTaskList[index].taskIsDone,
                        onChanged: (value) {
                          Provider.of<TaskProvider>(context, listen: false)
                              .updateCheckProperty(
                                  taskProvider.showingTaskList[index]);
                          if (value) {
                            Scaffold.of(context).showSnackBar(MySnackBar()
                                .snackBarWithContent(
                                    snackBarContent: "Task Completed",
                                    snackBarColor: kFieldColor));
                          }
                        },
                      )
                    ],
                  ),
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
                              Visibility(
                                visible: taskProvider
                                    .showingTaskList[index].dueDateExist,
                                child: Text(
                                  "Task Due Date:   " +
                                      taskProvider
                                          .showingTaskList[index].taskDay
                                          .toString() +
                                      "." +
                                      taskProvider
                                          .showingTaskList[index].taskMonth
                                          .toString() +
                                      "." +
                                      taskProvider
                                          .showingTaskList[index].taskYear
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: kRobotoTextStyle,
                                      fontWeight: FontWeight.bold),
                                ),
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
                                  FocusScope.of(context).unfocus();
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
                                  color: Colors.red.shade400,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
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
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                    MySnackBar()
                                                        .snackBarWithContent(
                                                            snackBarContent:
                                                                "Task Deleted",
                                                            snackBarColor:
                                                                Colors.red
                                                                    .shade400),
                                                  );
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
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    DueDateProvider dueDateProvider =
        Provider.of<DueDateProvider>(context, listen: false);
    MyModalBottomSheet myModalBottomSheet = MyModalBottomSheet(
        context: context, index: index, modalBottomSheetChild: child);
    if (taskProvider.showingTaskList[index].dueDateExist == false) {
      dueDateProvider.date = DateTime.now();
    }
    myModalBottomSheet.showModalSheet();
  }

  void addTask(BuildContext context, Widget child) {
    DueDateProvider dueDateProvider =
        Provider.of<DueDateProvider>(context, listen: false);
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    dueDateProvider.date = DateTime.now();
    taskProvider.inactivateColor();
    taskProvider.taskIsDoneCount();
    MyModalBottomSheet myModalBottomSheet =
        MyModalBottomSheet(context: context, modalBottomSheetChild: child);
    myModalBottomSheet.showModalSheet();
  }

  String taskPriorityNameFunc(BuildContext context, int index) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    String taskPriorityName;
    if (taskProvider.showingTaskList[index].taskPriority == 1) {
      taskPriorityName = "Less";
    }
    if (taskProvider.showingTaskList[index].taskPriority == 2) {
      taskPriorityName = "Middle";
    }
    if (taskProvider.showingTaskList[index].taskPriority == 3) {
      taskPriorityName = "More";
    }
    if (taskProvider.showingTaskList[index].taskPriority == 0) {
      taskPriorityName = "Unspecified";
    }
    return taskPriorityName;
  }

  void navigateEditTaskPage(BuildContext context, int index) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    DueDateProvider dueDateProvider =
        Provider.of<DueDateProvider>(context, listen: false);
    taskProvider.inactivateColor();
    taskProvider.currentContainer =
        taskProvider.showingTaskList[index].taskPriority;
    dueDateProvider.dateYear = taskProvider.showingTaskList[index].taskYear;
    dueDateProvider.dateMonth = taskProvider.showingTaskList[index].taskMonth;
    dueDateProvider.dateDay = taskProvider.showingTaskList[index].taskDay;
    dueDateProvider.checkboxDueDateValue =
        taskProvider.showingTaskList[index].dueDateExist;
    dueDateProvider.date = DateTime.utc(dueDateProvider.dateYear,
        dueDateProvider.dateMonth, dueDateProvider.dateDay);

    taskProvider.activateColor();
  }

  Icon priorityIcon(BuildContext context, int index) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    Icon priorityIcon;
    if (taskProvider.showingTaskList[index].taskPriority == 3) {
      priorityIcon = Icon(Icons.filter_1, color: kFieldColor);
    } else if (taskProvider.showingTaskList[index].taskPriority == 2) {
      priorityIcon = Icon(
        Icons.filter_2,
        color: kFieldColor,
      );
    } else if (taskProvider.showingTaskList[index].taskPriority == 1) {
      priorityIcon = Icon(
        Icons.filter_3,
        color: kFieldColor,
      );
    } else if (taskProvider.showingTaskList[index].taskPriority == 0)
      priorityIcon = Icon(
        Icons.filter_none,
        color: kFieldColor,
      );
    return priorityIcon;
  }
}
