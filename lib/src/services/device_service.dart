import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';

class DeviceService {
  // final String baseUrl = 'localhost:8080/devices';
  final String baseUrl =
      'https://bastion-server-951fbdb64d29.herokuapp.com/devices';

  Future<List<Device>> fetchDevices() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var resData = json.decode(response.body)["data"] as List;
      return resData.map((i) => Device.fromJSON(i)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<List<Device>> addDevice(Device device) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(device.toMap()),
    );
    if (response.statusCode == 201) {
      var resData = json.decode(response.body)["data"] as List;
      return resData.map((i) => Device.fromJSON(i)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<List<Device>> editDevice(Device device) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${device.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(device.toMap()),
    );
    if (response.statusCode == 201) {
      var resData = json.decode(response.body)["data"] as List;
      return resData.map((i) => Device.fromJSON(i)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<List<Device>> toggleDevice(Device device, bool toOn) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${device.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "id": device.id,
        "name": device.name,
        "type": device.type,
        "isOn": toOn,
      }),
    );
    if (response.statusCode == 201) {
      var resData = json.decode(response.body)["data"] as List;
      return resData.map((i) => Device.fromJSON(i)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<List<Device>> deleteDevice(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 201) {
      var resData = json.decode(response.body)["data"] as List;
      return resData.map((i) => Device.fromJSON(i)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }
}
