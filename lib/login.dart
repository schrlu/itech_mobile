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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    usernameController.text = widget.prefs.getString('username')!;
    passwordController.text = widget.prefs.getString('password')!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Center(
                child: SizedBox(
                    width: 300,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('images/Itech.png')),
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Passwort',
                    hintText: 'Dein Moodle-Passwort'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 20),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: tokenController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '2FA-Token',
                    hintText: 'Zweifaktor Authentifizierungs-Token'),
              ),
            ),
            CheckboxListTile(
              value: widget.prefs.getBool('rememberLogin'),
              title: const Text('Anmeldedaten speichern'),
              onChanged: (newValue) {
                setState(() {
                  widget.prefs.setBool('rememberLogin', newValue!);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    if (await OwnApi.login(usernameController.text,
                        passwordController.text, tokenController.text)) {
                      if (widget.prefs.getBool('rememberLogin') == true) {
                        widget.prefs
                            .setString('username', usernameController.text);
                        widget.prefs
                            .setString('password', passwordController.text);
                      } else {
                        widget.prefs.setString('username', '');
                        widget.prefs.setString('password', '');
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Timetable()));
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: const Text(
                'Passwort vergessen',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            TextButton(
              child: const Text(
                  'Neu? Hier Zweifaktor Authentifizierung einrichten'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Signup(),
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
