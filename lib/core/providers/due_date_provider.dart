import 'package:flutter/material.dart';

class DueDateProvider extends ChangeNotifier {
  bool checkboxDueDateValue = false;
  DateTime date = DateTime.utc(2020, 4, 19);
  int dateYear;
  int dateMonth;
  int dateDay;
  void checkboxDueDateEdit(bool value) {
    checkboxDueDateValue = value;
    notifyListeners();
  }

  Future<Null> selectDate(BuildContext context) async {
    DateTime datePicker = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (datePicker != null && datePicker != date) {
      date = datePicker;
      dateYear = date.year;
      dateMonth = date.month;
      dateDay = date.day;
      notifyListeners();
    }
  }

  String dueDateText() {
    String dueDateText;
    if (checkboxDueDateValue) {
      dueDateText = "Due Date Added";
    }
    if (checkboxDueDateValue == false) {
      dueDateText = "Add Due Date";
    }
    return dueDateText;
  }
}
