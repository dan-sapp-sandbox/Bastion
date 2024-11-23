import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';

class DeviceService {
  // final String baseUrl = 'localhost:8080/devices';
  final String baseUrl =
      'https://bastion-server-951fbdb64d29.herokuapp.com/devices';

  Future<List<Device>> fetchDevices() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        var resData = json.decode(response.body)["data"]["items"] as List;
        return resData.map((i) => Device.fromJSON(i)).toList();
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addDevice(Map<String, dynamic> device) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(device),
      );
      return response.statusCode == 200;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteDevice(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> toggleDevice(Device device, bool toOn) async {
    try {
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
      return response.statusCode == 200;
    } catch (error) {
      rethrow;
    }
  }
}
