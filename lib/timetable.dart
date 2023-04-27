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
  // Variablen Deklaration
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
          actions: [
            markClass(context, widget.prefs),
            OwnApi.logButton(widget.prefs)
          ],
        ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: OwnApi.getTimetable(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        // Gruppenwechsel über zweidimensionales Array
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
                                  child: printContent(snapshot.data as String),
                                )
                            ],
                          )
                      ],
                    );
                  } else {
                    return const Center(child: Text('Lädt...'));
                  }
                })),
        floatingActionButton: createRefreshButton());
  }

  // Button zum aktualisieren des Vertretungsplan
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
      tooltip: 'refresh',
      child: const Icon(
        color: Colors.white,
        Icons.refresh,
      ),
    );
  }

  // Ausgabe eines einzelnen Elements
  Container printContent(String data) {
    // Bestimmung der Hintergrundfarbe des Elements
    if (widget.prefs.containsKey('studentClass') &&
        widget.prefs.getString('studentClass') ==
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
    // Formatierung des Vertretungsplanelements
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

  // Auslesen der jeweiligen Information
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

  // Trenner-Element zwischen den Wochentagen
  Container newWeekDay(String data) {
    DateTime date =
        DateTime.parse(jsonDecode(data)['dates'][i]['date'].toString());
    color = Colors.blue.shade800;

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

  // Button zur Bestimmung der zu markierenden Klasse
  TextButton markClass(BuildContext context, SharedPreferences prefs) {
    final classController = TextEditingController();
    return TextButton(
      child: Text(
          '${prefs.getString('studentClass') != '' ? prefs.getString('studentClass') : 'Klasse markieren'}'),
      onPressed: () {
        // Dialog mit Textfeld zur Eingabe der Klasse
        showDialog(
            context: context,
            builder: (BuildContext context) {
              classController.text = prefs.getString('studentClass')!;
              return SimpleDialog(
                title: const Text('Gebe deine Klasse an, um sie zu markieren'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        decoration: const InputDecoration(
                            labelText: 'Klasse',
                            hintText: 'z.B. IT_n',
                            border: OutlineInputBorder()),
                        controller: classController,
                        onSubmitted: (value) {
                          prefs.setString('studentClass', value.toLowerCase());
                          Navigator.of(context).pop();
                          setState(() {});
                        }),
                  ),
                  // Reihe mit Buttons zum bestätigen und und abbrechen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextButton(
                            child: const Text('Keine Klasse wählen'),
                            onPressed: () {
                              prefs.setString('studentClass', '');
                              Navigator.of(context).pop();
                              setState(() {});
                            }),
                      ),
                      Flexible(
                        child: TextButton(
                            onPressed: () {
                              prefs.setString('studentClass',
                                  classController.text.toLowerCase());
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const Text('Bestätigen')),
                      ),
                    ],
                  )
                ],
              );
            });
      },
    );
  }
}
