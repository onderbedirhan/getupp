import 'package:flutter/material.dart';
import 'package:professional/view/screens/settings_page.dart';
import 'package:provider/provider.dart' show Provider;
import '../../core/constants/constants.dart';
import '../../core/models/task_model.dart';
import '../../core/providers/bottom_nav_provider.dart';
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
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarProvider provider =
        Provider.of<BottomNavigationBarProvider>(context);

    return Scaffold(
      appBar: AppBar(
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
