import 'package:flutter/material.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate<Task> {
  List<Task> recentTasks = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(
        color: Colors.black,
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
      color: Colors.black,
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //show some result based on the selection

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    List<Task> suggestionList = query.isEmpty
        ? recentTasks
        : taskProvider.myList
            .where((p) => p.taskName.toLowerCase().startsWith(query))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
            
        },
        leading: Icon(Icons.list),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].taskName.substring(0,query.length),
            style: TextStyle(
              color: Colors.black,fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: suggestionList[index].taskName.substring(query.length),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
