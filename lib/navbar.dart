import 'package:flutter/material.dart';
import 'package:itech_mobile/holiday.dart';
import 'package:itech_mobile/timetable.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Routen zu den anderen Seiten
    return Drawer(
        backgroundColor: Color.fromARGB(255, 1, 5, 6),
        key: Key('navBar'),
        child: ListView(
          children: [
            Site('Stundenplan', Icons.schedule, Timetable(), 'timetable'),
            Site('Ferienplan', Icons.schedule, Holiday(), 'holiday'),
          ],
        ));
  }
}

class Site extends StatelessWidget {
  IconData icon;
  Widget page;
  String title;
  String keyValue;

  Site(this.title, this.icon, this.page, this.keyValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
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
      ),
    );
  }
}
