import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class SettingsProvider extends ChangeNotifier {
  bool isHideCompletedTask = false;
  SharedPreferences mySharedPreferences;

  SettingsProvider() {
    getSettingsData();
  }

  void hideCompletedTaskFunc(bool value) {
    isHideCompletedTask = value;
    setSettingsData();
    getSettingsData();
  }

  void setSettingsData() {
    mySharedPreferences.setBool("isHideCompletedTask", isHideCompletedTask);
    notifyListeners();
  }

  void getSettingsData() async {
    mySharedPreferences = await SharedPreferences.getInstance();
    isHideCompletedTask = mySharedPreferences.getBool("isHideCompletedTask");
    notifyListeners();
  }
}
