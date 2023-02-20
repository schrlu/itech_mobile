import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ownapi.dart';

class Blockplan extends StatefulWidget {
  final SharedPreferences prefs;
  Blockplan({Key? key, required this.prefs}) : super(key: key);

  @override
  State<Blockplan> createState() => _BlockplanState();
}

class _BlockplanState extends State<Blockplan> {
  late int i;

  final format = DateFormat('dd.MM.yyy');

  Color color = Colors.black;

  String dropdownItem = '';

  @override
  Widget build(BuildContext context) {
    if (widget.prefs.getString('blockplanClass') != '' &&
        widget.prefs.containsKey('blockplanClass')) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
                'Blockplan für ${widget.prefs.getString('blockplanClass')}')),
      );
    } else {
      return Scaffold(
        body: FutureBuilder(
          future: OwnApi.authstatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return FutureBuilder(
                  future: OwnApi.getClasses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      getItems(snapshot.data!);
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Gebe deine Klasse an'),
                        ),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButton(
                                hint: Text('Bitte Klasse wählen'),
                                items: getItems(snapshot.data!)
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
                                  child: const Text('Das ist meine Klasse!'),
                                  onPressed: () {
                                    widget.prefs.setString(
                                        'blockplanClass', dropdownItem);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Blockplan(prefs: widget.prefs),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Scaffold(
                        body: Center(child: Text('Lädt...')),
                      );
                    }
                  },
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(prefs: widget.prefs),
                  ),
                );
                return Scaffold(
                  appBar: AppBar(title: Text('bla')),
                  body: Center(child: Text('hi')),
                );
              }
            } else {
              return Center(
                child: Text('Lädt...'),
              );
            }
          },
        ),
      );

      // SimpleDialog(
      //   title: const Text(
      //       'Gebe deine Klasse an, um deine Blockzeiten herauszufinden'),
      //   children: [
      //     Text('${prefs.getKeys()}'),
      //     TextButton(
      //         child: const Text('Keine Klasse wählen'),
      //         onPressed: () {
      //           prefs.remove('studentClass');
      //         })
      //   ],
      // );
    }
  }

  List<String> getItems(String items) {
    List<String> classList = [];
    for (var i = 0; i < jsonDecode(items).length; i++) {
      classList.add(jsonDecode(items)[i]['name']);
    }
    print(classList);

    if (dropdownItem == '') {
      dropdownItem = classList[0];
    }
    // print(list);
    return classList;
  }
}
