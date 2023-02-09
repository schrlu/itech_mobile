import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SharedPreferences prefs;
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(title: const Text('Itech-Mobile')),
        body: FutureBuilder(
            future: getPreferences(),
            builder: (context, snapshot) {
              prefs = snapshot.data!;
              return ListView(
                children: [
                  classSetting(context),

                ],
              );
            }));
  }

  Container classSetting(BuildContext context) {
    return Container(
                  color: getColor(),
                  child: ListTile(
                    title: Text(
                        'Klasse: ${prefs.getString('studentClass') != null ? prefs.getString('studentClass') : 'Nicht gewählt'}'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                  'Gebe deine Klasse an, um dich betreffende Informationen hervorzuheben'),
                              children: [
                                TextField(onSubmitted: (value) {
                                  prefs.setString('studentClass', value.toLowerCase());
                                  Navigator.of(context).pop();
                                  setState(() {});
                                }),
                                Container(
                                  child: TextButton(
                                      child: Text('Keine Klasse wählen'),
                                      onPressed: () {
                                        prefs.remove('studentClass');
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      }),
                                )
                              ],
                            );
                          });
                    },
                  ),
                );
  }

  Color getColor() {
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
    return color;
  }

  void setStudentClass(String studentClass) {
    prefs.setString('studentClass', studentClass);
  }

  Future<SharedPreferences> getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('studentClass') == null) {
      // tbc
    }
    return prefs;
  }
}