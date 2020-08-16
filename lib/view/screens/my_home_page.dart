import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/helpers/convert_task.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/bottom_nav_provider.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:professional/view/components/widgets/data_search.dart';
import 'package:professional/view/components/widgets/modal_bottom_sheet.dart';
import 'package:professional/view/screens/add_task_screen.dart';
import 'package:professional/view/screens/edit_task_screen.dart';
import 'package:professional/view/screens/family_page.dart';
import 'package:professional/view/screens/tags_page.dart';
import 'package:professional/view/screens/tasks_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatelessWidget {
  String taskName = "";
  var formKey = GlobalKey<FormState>();
  List<Task> myList = List();
  var mySharedPreferences;

  var currentTab = [
    TasksPage(),
    TagsPage(),
    FamilyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: kFieldColor,
              size: 30,
            ),
            onPressed: () {
              addTask(context, AddTaskScreen());
            },
          ),
        ],
        backgroundColor: kMiniFieldColor,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Get",
                style: TextStyle(
                  fontFamily: "Roboto",
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              TextSpan(
                text: "Upp",
                style: TextStyle(
                  fontFamily: "Russo",
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: currentTab[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Tasks"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            title: Text("Tags"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text("Family"),
          ),
        ],
      ),
    );
  }

  void addTask(BuildContext context, Widget child) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    taskProvider.inactivateColor();
    taskProvider.taskIsDoneCount();
    taskProvider.date = DateTime.now();
    taskProvider.checkboxDueDateValue=false;
    MyModalBottomSheet myModalBottomSheet =
        MyModalBottomSheet(context: context, modalBottomSheetChild: child);
    myModalBottomSheet.showModalSheet();
  }
}
