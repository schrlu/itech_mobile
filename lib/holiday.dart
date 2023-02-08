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
  late int j;
  final format = DateFormat('dd.MM.yyy');
  Color color = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('Itech-Mobile'),
        ),
        body: FutureBuilder(
            future: Api.getHoliday(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: [
                  for (int i = 0;
                      i < jsonDecode(snapshot.data as String).length; i++)
                    Text('${jsonDecode(snapshot.data as String)[i]}')
                ]);
              } else {
                return Center(child: Text('Lädt...'));
              }
            }));
  }
}

