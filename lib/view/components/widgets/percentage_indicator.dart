import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:provider/provider.dart';

class PercentageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return CircularPercentIndicator(
      radius: 60.0,
      animation: true,
      animationDuration: 1200,
      lineWidth: 5.0,
      percent: taskProvider.taskPercent,
      center: new Text(
        "%" + (taskProvider.taskPercent * 100).toStringAsFixed(0),
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18.0, color: kFieldColor),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: kMiniFieldColor,
      progressColor: kFieldColor,
    );
  }
}
