import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/models/task_model.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:professional/view/screens/edit_task_screen.dart';

import 'package:provider/provider.dart';

class MyDismissibleWidget extends StatelessWidget {
  int index;
  Widget dismissibleChild;
  Function onDismissed;

  MyDismissibleWidget({
    this.index,
    this.dismissibleChild,
    this.onDismissed(DismissDirection dismissDirection),
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      child: dismissibleChild,
      secondaryBackground: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Delete Task",
              style:
                  TextStyle(color: Colors.white, fontFamily: kRobotoTextStyle),
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kFieldColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "Edit Task",
              style:
                  TextStyle(color: Colors.white, fontFamily: kRobotoTextStyle),
            ),
          ],
        ),
      ),
      onDismissed: onDismissed,
    );
  }
}
