import 'package:flutter/material.dart';
import 'package:itech_mobile/holiday.dart';
import 'package:itech_mobile/settings.dart';
import 'package:itech_mobile/timetable.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    //Routen zu den anderen Seiten
    return Drawer(
        backgroundColor: const Color.fromARGB(255, 1, 5, 6),
        key: const Key('navBar'),
        child: ListView(
          children: [
            Site('Vertretungsplan', Icons.schedule, const Timetable(),
                'timetable'),
            Site('Ferienplan', Icons.beach_access, const Holiday(), 'holiday'),
            Site('Einstellungen', Icons.settings, const Settings(), 'settings'),
          ],
        ));
  }
}

// ignore: must_be_immutable
class Site extends StatelessWidget {
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
    );
  }
}
