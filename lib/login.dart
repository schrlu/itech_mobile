// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:itech_mobile/ownapi.dart';
import 'package:itech_mobile/signup.dart';
import 'package:itech_mobile/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final SharedPreferences prefs;
  const Login({Key? key, required this.prefs}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Erstellung der Controller für die Textfelder
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    if (usernameController.text == '') {
      usernameController.text = widget.prefs.getString('username')!;
    }
    if (passwordController.text == '') {
      passwordController.text = widget.prefs.getString('password')!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      // Bild scrollable machen, falls der Bildschirm zu klein ist
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Ausgabe des Itech-Logos
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Center(
                child: SizedBox(
                    width: 300,
                    height: 150,
                    child: Image.asset('images/Itech.png')),
              ),
            ),
            // Eingabefeld Benutzername
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Benutzer',
                    hintText: 'Moodle-Benutzername'),
              ),
            ),
            // Eingabefeld Passwort
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: passwordController,
                obscureText: passwordVisible,
                // Button für Sichtbarkeit/Unsichtbarkeit des Passworts
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Passwort',
                    hintText: 'Dein Moodle-Passwort'),
              ),
            ),
            // Eingabefeld 2FA-Token
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 20),
              child: TextField(
                controller: tokenController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '2FA-Token',
                    hintText: 'Zweifaktor Authentifizierungs-Token'),
              ),
            ),
            // Checkbox für merken des Passworts und Benutzernamens
            CheckboxListTile(
              value: widget.prefs.getBool('rememberLogin'),
              title: const Text('Anmeldedaten speichern'),
              onChanged: (newValue) {
                setState(() {
                  widget.prefs.setBool('rememberLogin', newValue!);
                });
              },
            ),
            // Login Button
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      // Bei betätigung Login-Status in der Snackbar anzeigen
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login...")));
                        // Bei erfolgreichem Login + aktivierten remember Login
                        // werden die Login-Daten gespeichert
                        if (await OwnApi.login(usernameController.text,
                            passwordController.text, tokenController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Login erfolgreich")));
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          if (widget.prefs.getBool('rememberLogin') == true) {
                            widget.prefs
                                .setString('username', usernameController.text);
                            widget.prefs
                                .setString('password', passwordController.text);
                          } else {
                            widget.prefs.setString('username', '');
                            widget.prefs.setString('password', '');
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Timetable(prefs: widget.prefs)),
                              (Route<dynamic> route) => false);
                        } else {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Login fehlgeschlagen")));
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  // Button für Nutzung ohne Anmeldung
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Timetable(prefs: widget.prefs)),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        'Ohne Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Button zur Registrationsseite
            TextButton(
              child: const Text(
                  'Neu? Hier Zweifaktor Authentifizierung einrichten'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signup(
                      prefs: widget.prefs,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
