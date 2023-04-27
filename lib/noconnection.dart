import 'dart:io';

import 'package:flutter/material.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ownapi.dart';

class NoConnection extends StatefulWidget {
  final SharedPreferences prefs;
  const NoConnection({Key? key, required this.prefs}) : super(key: key);

  @override
  State<NoConnection> createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  // Variablen Deklaration
  late Widget startWidget;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keine Internet-Verbindung'),
      ),
      body: Center(
          child: TextButton(
        child: const Text('Erneut versuchen'),
        onPressed: () async {
          // Test der Internet Verbindung, bei erfolg → Weiterleitung zur Login Seite
          try {
            final result = await InternetAddress.lookup('example.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              if (await OwnApi.authstatus()) {
                startWidget = Timetable(
                  prefs: widget.prefs,
                );
              } else {
                startWidget = Login(prefs: widget.prefs);
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
                home: NoConnection(
                  prefs: widget.prefs,
                )));
          }
        },
      )),
    );
  }
}
