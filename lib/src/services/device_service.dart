import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';

class DeviceService {
  // final String baseUrl = 'http://localhost:8080';
  final String baseUrl = 'https://bastion-server-951fbdb64d29.herokuapp.com';

  Future<void> addDevice(Device device) async {
    await http.post(
      Uri.parse('$baseUrl/add-device'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(device.toMap()),
    );
    return;
  }

  Future<void> editDevice(Device device) async {
    await http.put(
      Uri.parse('$baseUrl/edit-device/${device.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(device.toMap()),
    );
    return;
  }

  Future<void> toggleDevice(Device device, bool toOn) async {
    await http.put(
      Uri.parse('$baseUrl/edit-device/${device.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "id": device.id,
        "name": device.name,
        "type": device.type,
        "room": device.room,
        "isOn": toOn,
      }),
    );
    return;
  }

  Future<void> deleteDevice(int id) async {
    await http.delete(Uri.parse('$baseUrl/delete-device/$id'));
    return;
  }
}
