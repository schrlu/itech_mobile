// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itech_mobile/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnApi {
  // API Request für Vertretungsplan
  static Future<String> getTimetable() async {
    var client = HttpClient();
    HttpClientRequest request =
        await client.get('api.itech-bs14.de', 80, '/standin');
    HttpClientResponse response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    // print(stringData);
    client.close();
    return stringData;
  }

  // API Request für Ferienplan
  static Future<String> getHoliday() async {
    var client = HttpClient();
    HttpClientRequest request =
        await client.get('api.itech-bs14.de', 80, '/holiday');
    HttpClientResponse response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    client.close();
    return stringData;
  }

  // API Request für News
  static Future<String> getNews() async {
    var client = HttpClient();
    HttpClientRequest request =
        await client.get('api.itech-bs14.de', 80, '/news');
    HttpClientResponse response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    client.close();
    return stringData;
  }

  // API Request für Login
  static Future<bool> login(
      String username, String password, String token) async {
    var client = http.Client();
    final prefs = await SharedPreferences.getInstance();
    var headers = {'Content-Type': 'application/json'};
    var response = await client.post(
        Uri.parse('https://api.itech-bs14.de/login'),
        body: json.encode({
          "username": "$username",
          "password": "$password",
          "code": "$token"
        }),
        headers: headers);

    if (response.statusCode == 200) {
      await prefs.setString(
          'apiKey', jsonDecode(utf8.decode(response.bodyBytes))['token']);
      client.close();
      return true;
    } else {
      client.close();
      return false;
    }
  }

  // API Request für Registration
  static Future<bool> signUp(
      String username, String password, String email) async {
    var client = http.Client();
    var headers = {'Content-Type': 'application/json'};
    var response = await client.post(
        Uri.parse('https://api.itech-bs14.de/register'),
        body: json.encode({
          "username": "$username",
          "password": "$password",
          "email": "$email"
        }),
        headers: headers);

    if (response.statusCode == 200) {
      client.close();
      return true;
    } else {
      client.close();
      return false;
    }
  }

  // API Request für Authentifizierungsstatus
  static Future<bool> authstatus() async {
    final prefs = await SharedPreferences.getInstance();
    var client = http.Client();
    var headers = {'Authorization': 'Bearer ${prefs.getString('apiKey')}'};
    var response = await client.get(
        Uri.parse('https://api.itech-bs14.de/authstatus'),
        headers: headers);

    if (response.statusCode == 200) {
      client.close();
      return true;
    } else {
      // print('${response.reasonPhrase}${response.statusCode}');
      client.close();
      return false;
    }
  }

  // API Request für Klassenliste
  static Future<String> getClasses() async {
    var client = http.Client();
    final prefs = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ${prefs.getString('apiKey')}'};
    var response = await client
        .get(Uri.parse('https://api.itech-bs14.de/klasse'), headers: headers);

    if (response.statusCode == 200) {
      client.close();
      return utf8.decode(response.bodyBytes);
    } else {
      client.close();
      return '';
    }
  }

  // API Request für Blockzeiten
  static Future<String> getBlockTime() async {
    var client = http.Client();
    final prefs = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ${prefs.getString('apiKey')}'};
    var response = await client.get(
        Uri.parse(
            'https://api.itech-bs14.de/klasse/${prefs.getInt('classId')}'),
        headers: headers);

    if (response.statusCode == 200) {
      client.close();
      return utf8.decode(response.bodyBytes);
    } else {
      client.close();
      // print('${response.reasonPhrase}${response.statusCode}');
      return '';
    }
  }

  // Login/Out Button
  static Widget logButton(SharedPreferences prefs) {
    return FutureBuilder(
        future: OwnApi.authstatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return TextButton(
                  onPressed: () {
                    prefs.setString('apiKey', '');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => Login(prefs: prefs)),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text('Logout'));
            } else {
              return TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => Login(prefs: prefs)),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text('Login'));
            }
          } else {
            return Container();
          }
        });
  }
}
