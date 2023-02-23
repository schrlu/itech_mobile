import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ownapi.dart';

class Blockplan extends StatefulWidget {
  final SharedPreferences prefs;
  const Blockplan({Key? key, required this.prefs}) : super(key: key);

  @override
  State<Blockplan> createState() => _BlockplanState();
}

class _BlockplanState extends State<Blockplan> {
  late int i;

  final format = DateFormat('dd.MM.yyy');

  Color color = Colors.black;

  String dropdownItem = '';
  late List<String> itemList;

  bool auth = false;

  @override
  Widget build(BuildContext context) {
    // widget.prefs.setString('apiKey', '7');
    return Scaffold(
      drawer: NavBar(prefs: widget.prefs),
      appBar:
          AppBar(title: const Text('Itech-Blockplanung'), actions: [chooseClass()]),
      body: FutureBuilder(
        future: OwnApi.authstatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            auth = snapshot.data!;
            if (auth) {
              if (widget.prefs.getString('blockplanClass') != '' &&
                  widget.prefs.containsKey('blockplanClass')) {
                return ListView(
                  children: [
                    FutureBuilder(
                      future: OwnApi.getBlockTime(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [Text('${snapshot.data}')],
                          );
                        } else {
                          return const Center(
                            child: Text('Lädt...'),
                          );
                        }
                      },
                    )
                  ],
                );
              } else {
                return Center(child: chooseClass());
              }
            } else {
              return Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(prefs: widget.prefs),
                            ));
                      },
                      child: const Text(
                          'Für diesen Bereich musst du dich anmelden')));
              //
            }
          } else {
            return const Scaffold(
                body: Center(
              child: Text('Lädt...'),
            ));
          }
        },
      ),
    );
  }

  TextButton chooseClass() {
    return TextButton(
        onPressed: () {
          if (auth) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SimpleDialog(
                        title: const Text('Klasse auswählen'),
                        children: [
                          FutureBuilder(
                            future: OwnApi.getClasses(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                itemList = getItems(snapshot.data!);
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DropdownButton(
                                        hint: const Text('Bitte Klasse wählen'),
                                        items: itemList
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownItem = newValue!;
                                          });
                                        },
                                        value: dropdownItem,
                                      ),
                                      TextButton(
                                          child: const Text(
                                              'Das ist meine Klasse!'),
                                          onPressed: () {
                                            widget.prefs.setString(
                                                'blockplanClass', dropdownItem);
                                            widget.prefs.setInt(
                                                'classId',
                                                itemList.indexOf(widget.prefs
                                                        .getString(
                                                            'blockplanClass')!) +
                                                    1);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Blockplan(
                                                    prefs: widget.prefs),
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(child: Text('Lädt...'));
                              }
                            },
                          )
                        ],
                      );
                    },
                  );
                });
          }
        },
        child: const Text('Klasse auswählen'));
  }

  List<String> getItems(String items) {
    List<String> classList = [];

    if (items != '') {
      for (var i = 0; i < jsonDecode(items).length; i++) {
        classList.add(jsonDecode(items)[i]['name']);
      }
    }

    if (dropdownItem == '') {
      dropdownItem = classList[0];
    }

    return classList;
  }
}
