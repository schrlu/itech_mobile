import 'dart:convert';

import 'package:http/http.dart' as http;

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
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('https://api.itech-bs14.de/login'));
    request.body = json.encode(
        {"username": "$username", "password": "$password", "code": "$token"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }
}
