// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OwnApi {
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

  static Future<String> getHoliday() async {
    var client = HttpClient();
    HttpClientRequest request =
        await client.get('api.itech-bs14.de', 80, '/holiday');
    HttpClientResponse response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    client.close();
    return stringData;
  }

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
      // print('${response.reasonPhrase}${response.statusCode}');
      client.close();
      return false;
    }
  }

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
      // print('${response.reasonPhrase}${response.statusCode}');
      client.close();
      return '';
    }
  }

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
}
