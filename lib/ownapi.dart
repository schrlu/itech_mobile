import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OwnApi {
  static Future<String> getTimetable() async {
    final httpsUri = Uri.https('api.itech-bs14.de', 'standin');
    final response = await http.get(httpsUri);
    return utf8.decode(response.bodyBytes);
  }

  static Future<String> getHoliday() async {
    final httpsUri = Uri.https('api.itech-bs14.de', 'holiday');
    final response = await http.get(httpsUri);
    return utf8.decode(response.bodyBytes);
  }

  static Future<bool> login(
      String username, String password, String token) async {
    final prefs = await SharedPreferences.getInstance();
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('https://api.itech-bs14.de/login'));
    request.body = json.encode(
        {"username": "$username", "password": "$password", "code": "$token"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      await prefs.setString(
          'apiKey', jsonDecode(await response.stream.bytesToString())['token']);
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future<bool> authstatus() async {
    final prefs = await SharedPreferences.getInstance();
    var headers = {
      'Authorization': 'Bearer ${await prefs.getString('apiKey')}'
    };
    var request =
        http.Request('GET', Uri.parse('https://api.itech-bs14.de/authstatus'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  static Future<String> getClasses() async {
    final prefs = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer ${prefs.getString('apiKey')}'};
    var request =
        http.Request('GET', Uri.parse('https://api.itech-bs14.de/klasse'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      print(response.reasonPhrase);
      return '';
    }
  }
}
