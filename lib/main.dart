import 'package:flutter/material.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/ownapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("rememberLogin")) {
    await prefs.setBool("rememberLogin", false);
  }
  if (!prefs.containsKey('username')) {
    prefs.setString('username', '');
  }
  if (!prefs.containsKey('password')) {
    prefs.setString('password', '');
  }
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Itech-Mobile',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: Login(prefs: prefs)));
}
