import 'package:flutter/material.dart';
import 'package:itech_mobile/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final SharedPreferences prefs;
  const Settings({Key? key, required this.prefs}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final classController = TextEditingController();
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(prefs: widget.prefs),
        appBar: AppBar(title: const Text('Itech-Mobile')),
        body: ListView(
          children: [
            classSetting(context, widget.prefs),
          ],
        ));
  }

  Container classSetting(BuildContext context, SharedPreferences prefs) {
    return Container(
      color: getColor(),
      child: ListTile(
        title: Text(
            'Vertretungsplanmarkierung: ${prefs.getString('studentClass') ?? 'Nicht gewählt'}'),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                classController.text = prefs.getString('studentClass')!;
                return SimpleDialog(
                  title:
                      const Text('Gebe deine Klasse an, um sie zu markieren'),
                  children: [
                    TextField(
                        controller: classController,
                        onSubmitted: (value) {
                          prefs.setString('studentClass', value.toLowerCase());
                          Navigator.of(context).pop();
                          setState(() {});
                        }),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              prefs.setString('studentClass',
                                  classController.text.toLowerCase());
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const Text('Bestätigen')),
                        const Spacer(),
                        TextButton(
                            child: const Text('Keine Klasse wählen'),
                            onPressed: () {
                              prefs.setString('studentClass', '');
                              Navigator.of(context).pop();
                              setState(() {});
                            }),
                      ],
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
}
