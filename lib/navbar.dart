import 'package:flutter/material.dart';
import 'package:itech_mobile/blockplan.dart';
import 'package:itech_mobile/holiday.dart';
import 'package:itech_mobile/news.dart';
import 'package:itech_mobile/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  final SharedPreferences prefs;
  const NavBar({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Routen zu den anderen Seiten
    return Drawer(
        backgroundColor: const Color.fromARGB(255, 1, 5, 6),
        key: const Key('navBar'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Site(
                'Vertretungsplan',
                Icons.schedule,
                Timetable(
                  prefs: prefs,
                ),
                'timetable'),
            Site(
                'Ferienplan',
                Icons.beach_access,
                Holiday(
                  prefs: prefs,
                ),
                'holiday'),
            Site('Blockplan', Icons.calendar_month, Blockplan(prefs: prefs),
                'blockplan'),
            Site('News', Icons.newspaper, News(prefs: prefs), 'news'),
          ],
        ));
  }
}

class Site extends StatelessWidget {
  // Variablen Deklaration
  IconData icon;
  Widget page;
  String title;
  String keyValue;

  Site(this.title, this.icon, this.page, this.keyValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(keyValue),
      textColor: Colors.white,
      leading: Icon(icon, color: Colors.white),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => page),
            (Route<dynamic> route) => false);
      },
    );
  }
}
