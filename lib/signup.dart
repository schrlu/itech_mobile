// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:itech_mobile/login.dart';
import 'package:itech_mobile/ownapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  final SharedPreferences prefs;
  const Signup({Key? key, required this.prefs}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
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
                obscureText: passwordVisible,
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-Mail',
                    hintText: 'someone@example.com'),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registration läuft...")));
                    if (await OwnApi.signUp(usernameController.text,
                        passwordController.text, emailController.text)) {
                      if (widget.prefs.getBool('rememberLogin') == true) {
                        widget.prefs
                            .setString('username', usernameController.text);
                        widget.prefs
                            .setString('password', passwordController.text);
                      } else {
                        widget.prefs.setString('username', '');
                        widget.prefs.setString('password', '');
                      }
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Registration erfolgreich")));
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Login(prefs: widget.prefs)),
                          (Route<dynamic> route) => false);
                    } else {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Registration fehlgeschlagen")));
                    }
                  },
                  child: const Text(
                    'Registrieren',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            TextButton(
              child: const Text('Bereits registriert? Hier gehts zum Login'),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(prefs: widget.prefs),
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
