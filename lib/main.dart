import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:professional/core/constants/constants.dart';
import 'package:professional/core/providers/due_date_provider.dart';
import 'package:professional/core/providers/task_provider.dart';
import 'package:professional/view/screens/my_home_page.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/providers/bottom_nav_provider.dart';

main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<BottomNavigationBarProvider>(
            create: (context) => BottomNavigationBarProvider()),
        ChangeNotifierProvider<DueDateProvider>(
            create: (context) => DueDateProvider()),
        ChangeNotifierProvider<TaskProvider>(
            create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: kFieldColor,
        ),
        debugShowCheckedModeBanner: false,
        title: "GetUpp",
        home: MyHomePage(),
      ),
    );
  }
}
