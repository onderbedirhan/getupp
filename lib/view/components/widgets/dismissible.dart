import 'package:flutter/material.dart';
import 'package:professional/core/constants/constants.dart';


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
