import 'dart:io';

import 'package:flutter/material.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/noconnection.dart';
import 'package:itech_mobile/ownapi.dart';
import 'package:itech_mobile/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Variablen Deklaration
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget startWidget;

  // Vorbefüllung der Präferenzen
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
  // Testen der Internetverbindung
  // Bei Aktiver Internet Verbindung → Leitung zum Login, sonst Fehler anzeigen
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
  } on SocketException catch (_) {
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Itech-Mobile',
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        home: NoConnection(prefs: prefs)));
  }
}
