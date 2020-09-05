import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import '../../core/constants/constants.dart';
import '../../core/providers/task_provider.dart';
import '../../core/providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProviderListenFalse =
        Provider.of<SettingsProvider>(context, listen: false);
    if (settingsProviderListenFalse.isHideCompletedTask == null) {
      settingsProviderListenFalse.isHideCompletedTask = false;
    }
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TaskProvider taskProviderListenFalse =
        Provider.of<TaskProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hide completed tasks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Switch(
                    activeColor: kFieldColor,
                    value: settingsProvider.isHideCompletedTask,
                    onChanged: (value) {
                      taskProviderListenFalse.taskIsDoneCount();
                      settingsProviderListenFalse.hideCompletedTaskFunc(value);
                      taskProviderListenFalse.isHideCompletedTask =
                          settingsProviderListenFalse.isHideCompletedTask;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
