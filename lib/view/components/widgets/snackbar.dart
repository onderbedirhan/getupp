import 'package:flutter/material.dart';

class MySnackBar {
  SnackBar snackBar;
  Color snackBarColor;
  SnackBar snackBarWithContent({String snackBarContent, Color snackBarColor}) {
    snackBar = SnackBar(
      backgroundColor: snackBarColor,
      content: Text(
        snackBarContent,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 1),
    );
    return snackBar;
  }
}
