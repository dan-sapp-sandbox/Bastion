import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/change_log.dart';

class ChangeLogService {
  // final String baseUrl = 'localhost:8080/change-log';
  final String baseUrl =
      'https://bastion-server-951fbdb64d29.herokuapp.com/change-log';

  Future<List<ChangeLogEntry>> fetchChangeLog() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var resData = json.decode(response.body)["data"] as List;
      return resData.map((i) => ChangeLogEntry.fromJSON(i)).toList();
    } else {
      throw Exception('Failed to load change log');
    }
  }
}
