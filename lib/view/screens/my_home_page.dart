import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/bottom_nav_provider.dart';
import 'package:professional/core/providers/due_date_provider.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:professional/view/components/widgets/modal_bottom_sheet.dart';
import 'package:professional/view/screens/add_task_screen.dart';
import 'package:professional/view/screens/family_page.dart';
import 'package:professional/view/screens/tags_page.dart';
import 'package:professional/view/screens/tasks_page.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  final String taskName = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<Task> myList = List();

  final List<StatelessWidget> currentTab = [
    TasksPage(),
    TagsPage(),
    FamilyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarProvider provider =
        Provider.of<BottomNavigationBarProvider>(context);

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
    DueDateProvider dueDateProvider =
        Provider.of<DueDateProvider>(context, listen: false);
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    taskProvider.inactivateColor();
    taskProvider.taskIsDoneCount();
    dueDateProvider.date = DateTime.now();
    dueDateProvider.checkboxDueDateValue = false;
    MyModalBottomSheet myModalBottomSheet =
        MyModalBottomSheet(context: context, modalBottomSheetChild: child);
    myModalBottomSheet.showModalSheet();
  }
}
