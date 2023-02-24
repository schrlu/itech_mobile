import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:itech_mobile/ownapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class News extends StatefulWidget {
  final SharedPreferences prefs;
  const News({Key? key, required this.prefs}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late int i;
  final format = DateFormat('dd.MM.yyy');
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(prefs: widget.prefs),
        appBar: AppBar(
          title: const Text('Itech-Mobile'),
          actions: [OwnApi.logButton(widget.prefs)],
        ),
        body: ListView(
          children: [
            FutureBuilder(
                future: OwnApi.getNews(),
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
                '${jsonDecode(snapshot.data!)[i]['news_image']} (von ${format.format(DateTime.parse(jsonDecode(snapshot.data!)[i]['news_date_from']))} bis ${format.format(DateTime.parse(jsonDecode(snapshot.data!)[i]['news_date_to']))})'),
            Text('${jsonDecode(snapshot.data!)[i]['news_body']}'),
          ],
        ),
      ),
    );
  }
}
