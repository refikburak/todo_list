import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_list/data/di/locator.dart';
import 'package:todo_list/pages/home_page.dart';

void main() async {
  await setupDI(Environment.prod);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        accentColor: Colors.deepPurple[400],
        snackBarTheme: SnackBarThemeData(
          actionTextColor: Colors.white,
          backgroundColor: Colors.grey[900],
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
