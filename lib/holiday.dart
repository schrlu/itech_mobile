import 'dart:convert';
import 'package:itech_mobile/ownapi.dart';
import 'package:flutter/material.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Holiday extends StatefulWidget {
  final SharedPreferences prefs;
  const Holiday({Key? key, required this.prefs}) : super(key: key);

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
        drawer: NavBar(prefs: widget.prefs),
        appBar: AppBar(
          title: const Text('Itech-Blockplan'),
          actions: [OwnApi.logButton(widget.prefs)],
        ),
        body: ListView(
          children: [
            FutureBuilder(
                future: OwnApi.getHoliday(),
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
                    return const Center(child: Text('Lädt...'));
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
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
