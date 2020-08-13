import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatelessWidget{
  String taskName = "";
  var formKey = GlobalKey<FormState>();

  int index;
  EditTaskScreen({this.index});
  @override
  Widget build(BuildContext context) {
    
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: kFieldColor,
                  child: Text(
                    "Edit",
                    style: TextStyle(color: kBackgroundColor),
                  ),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      Provider.of<TaskProvider>(context, listen: false)
                          .editTask(title: taskName, index: index);
                      Navigator.pop(context);
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
