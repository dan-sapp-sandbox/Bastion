import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'models/device.dart';

Future<bool> createDevice() async {
  // var url = Uri.parse('http://localhost:8080/devices');
  var url =
      Uri.parse('https://bastion-server-951fbdb64d29.herokuapp.com/devices');
  var newDevice = {'name': 'Bedroom', 'type': 'light', 'isOn': false};
  var payload = json.encode(newDevice);

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: payload,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to create devices');
  }
}

Future<bool> editDevice() async {
  // var url = Uri.parse('http://localhost:8080/devices');
  var url =
      Uri.parse('https://bastion-server-951fbdb64d29.herokuapp.com/devices');
  var newDevice = {'name': 'Front Door', 'type': 'lock'};
  var payload = json.encode(newDevice);

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: payload,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to create devices');
  }
}
