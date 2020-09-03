import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import '../../core/constants/constants.dart';
import '../../core/models/task_model.dart';
import '../../core/providers/bottom_nav_provider.dart';
import '../../core/providers/due_date_provider.dart';
import '../../core/providers/task_provider.dart';
import '../../view/components/widgets/modal_bottom_sheet.dart';
import '../../view/screens/add_task_screen.dart';
import '../../view/screens/family_page.dart';
import '../../view/screens/tags_page.dart';
import '../../view/screens/tasks_page.dart';

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
        iconSize: 24,
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
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void addTask(BuildContext context, Widget child) {
    FocusScope.of(context).unfocus();
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
