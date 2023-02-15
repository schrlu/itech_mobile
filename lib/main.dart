import 'package:flutter/material.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/timetable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itech-Mobile',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
