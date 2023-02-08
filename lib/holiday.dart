import 'dart:convert';
import 'dart:io';
import 'package:itech_mobile/api.dart';
import 'package:flutter/material.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:intl/intl.dart';

class Holiday extends StatefulWidget {
  @override
  State<Holiday> createState() => _HolidayState();
}

class _HolidayState extends State<Holiday> {
  late int i;
  final format = DateFormat('dd.MM.yyy');
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('Itech-Mobile'),
        ),
        body: ListView(
          children: [
            FutureBuilder(
                future: Api.getHoliday(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      for (int i = 0;
                          i < jsonDecode(snapshot.data as String).length;
                          i++)
                        printContent(snapshot, i, context)

                      // Text('${jsonDecode(snapshot.data as String)[i]}')
                    ]);
                  } else {
                    return Center(child: Text('Lädt...'));
                  }
                }),
          ],
        ));
  }

  Container printContent(
      AsyncSnapshot<String> snapshot, int i, BuildContext context) {
    if (Theme.of(context).indicatorColor != ThemeData().indicatorColor) {
      if (color == Colors.grey.shade800) {
        color = Colors.grey.shade700;
      } else {
        color = Colors.grey.shade800;
      }
    } else {
      if (color == Colors.grey.shade300) {
        color = Colors.grey.shade200;
      } else {
        color = Colors.grey.shade300;
      }
    }
    return Container(
      color: color,
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${jsonDecode(snapshot.data as String)[i]['name']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GridView.count(
              shrinkWrap: true,
              childAspectRatio: (MediaQuery.of(context).size.width * 8) /
                  (MediaQuery.of(context).size.height),
              crossAxisCount: 2,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Von ${format.format(DateTime.parse(jsonDecode(snapshot.data as String)[i]['start']))}'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'bis ${format.format(DateTime.parse(jsonDecode(snapshot.data as String)[i]['end']))}'),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}