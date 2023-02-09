import 'dart:convert';
import 'dart:io';
import 'package:itech_mobile/api.dart';
import 'package:flutter/material.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:intl/intl.dart';
import 'package:itech_mobile/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timetable extends StatefulWidget {
  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  late int i;
  late int j;
  final format = DateFormat('dd.MM.yyy');
  late SharedPreferences prefs;
  late Color color;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('Itech-Mobile'),
        ),
        body: FutureBuilder(
          future: getPreferences(),
          builder: (context, snapshot) {
            prefs = snapshot.data!;
            return ListView(
              children: <Widget>[
                FutureBuilder(
                    future: Api.getTimetable(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            for (i = 0;
                                i <
                                    jsonDecode(snapshot.data as String)['dates']
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
                                      child:
                                          printContent(snapshot.data as String),
                                    ),
                                ],
                              )
                          ],
                        );
                      } else {
                        return Center(child: Text('Lädt...'));
                      }
                    })
              ],
            );
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Aktualisiert"),
        ));
      },
      child: Icon(
        Icons.refresh,
        color: Colors.white,
      ),
      tooltip: 'refresh',
    );
  }

  Container printContent(String data) {
    if (prefs.getString('studentClass') ==
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
          title: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        childAspectRatio: (MediaQuery.of(context).size.width * 2.5) /
            (MediaQuery.of(context).size.height),
        children: [
          newContentColumn(data, 'Klasse', 'class'),
          newContentColumn(data, 'Zeit', 'time'),
          newContentColumn(data, 'Raum', 'room'),
          newContentColumn(data, 'Info', 'info'),
        ],
      )),
    );
  }

  Column newContentColumn(String data, String heading, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(heading),
        ),
        if (jsonDecode(data)['dates'][i]['results'][j][content] == "")
          Text('-')
        else
          Flexible(
              child: Text(
                  '${jsonDecode(data)['dates'][i]['results'][j][content]}')),
      ],
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
    if (prefs.getString('studentClass') == null) {
      // tbc
    }
    return prefs;
  }
}
