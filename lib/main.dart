import 'package:flutter/material.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/ownapi.dart';
import 'package:itech_mobile/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget startWidget;
  prefs.remove('blockplanClass');
  if (!prefs.containsKey('studentClass')) {
    await prefs.setString('studentClass', '');
  }
  if (!prefs.containsKey("rememberLogin")) {
    await prefs.setBool("rememberLogin", false);
  }
  if (!prefs.containsKey('username')) {
    prefs.setString('username', '');
  }
  if (!prefs.containsKey('password')) {
    prefs.setString('password', '');
  }

  if (await OwnApi.authstatus()) {
    startWidget = Timetable(
      prefs: prefs,
    );
  } else {
    startWidget = Login(prefs: prefs);
  }

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Itech-Mobile',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: startWidget));
}
