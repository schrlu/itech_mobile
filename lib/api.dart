import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
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
}
