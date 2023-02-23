import 'dart:convert';
import 'package:itech_mobile/ownapi.dart';
import 'package:flutter/material.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timetable extends StatefulWidget {
  final SharedPreferences prefs;
  const Timetable({Key? key, required this.prefs}) : super(key: key);

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  late int i;
  late int j;
  final format = DateFormat('dd.MM.yyy');
  late SharedPreferences? prefs;
  late Color color;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(
          prefs: widget.prefs,
        ),
        appBar: AppBar(
          title: const Text('Itech-Mobile'),
        ),
        body: FutureBuilder(
          future: getPreferences(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              prefs = snapshot.data!;
              return SingleChildScrollView(
                  child: FutureBuilder(
                      future: OwnApi.getTimetable(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              for (i = 0;
                                  i <
                                      jsonDecode(
                                              snapshot.data as String)['dates']
                                          .length;
                                  i++)
                                Column(
                                  children: [
                                    newWeekDay(snapshot.data as String),
                                    for (j = 0;
                                        j <
                                            jsonDecode(snapshot.data as String)[
                                                    'dates'][i]['results']
                                                .length;
                                        j++)
                                      Container(
                                        child: printContent(
                                            snapshot.data as String),
                                      )
                                  ],
                                )
                            ],
                          );
                        } else {
                          return const Center(child: Text('Lädt...'));
                        }
                      }));
            } else {
              return const Center(
                child: Text('Lädt...'),
              );
            }
          },
        ),
        floatingActionButton: createRefreshButton());
  }

  FloatingActionButton createRefreshButton() {
    if (Theme.of(context).indicatorColor != ThemeData().indicatorColor) {
      color = Colors.blue.shade800;
    } else {
      color = Colors.blue;
    }
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: () {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Aktualisiert"),
        ));
      },
      // ignore: sort_child_properties_last
      child: const Icon(
        color: Colors.white,
        Icons.refresh,
      ),
      tooltip: 'refresh',
    );
  }

  Container printContent(String data) {
    if (prefs!.containsKey('studentClass') &&
        prefs!.getString('studentClass') ==
            jsonDecode(data)['dates'][i]['results'][j]['class']
                .toString()
                .toLowerCase()) {
      color = Colors.pink;
    } else {
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
    }

    return Container(
      color: color,
      child: ListTile(
          title: Row(
        children: [
          newContentColumn(data, 'Klasse', 'class'),
          newContentColumn(data, 'Zeit', 'time'),
          newContentColumn(data, 'Raum', 'room'),
          newContentColumn(data, 'Info', 'info'),
        ],
      )),
    );
  }

  SizedBox newContentColumn(String data, String heading, String content) {
    return SizedBox(
      width: ((MediaQuery.of(context).size.width) / 4) - 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              heading,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (jsonDecode(data)['dates'][i]['results'][j][content] == "")
            const Text('-')
          else
            Flexible(
                child: Text(
                    '${jsonDecode(data)['dates'][i]['results'][j][content]}')),
        ],
      ),
    );
  }

  Container newWeekDay(String data) {
    DateTime date =
        DateTime.parse(jsonDecode(data)['dates'][i]['date'].toString());
    color = Colors.blue.shade800;

    // color = Colors.black;
    if (!jsonDecode(data)['dates'][i]['results'].isEmpty) {
      return Container(
          color: color,
          child: ListTile(
            title: Text(
                '${jsonDecode(data)['dates'][i]['week_day']}, ${format.format(date)}',
                style: TextStyle(
                    color:
                        Theme.of(context).primaryTextTheme.bodyMedium?.color)),
          ));
    } else {
      return Container();
    }
  }

  Future<SharedPreferences> getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs!;
  }
}
