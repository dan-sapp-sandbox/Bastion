import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/device.dart';

Future<List<Device>> fetchDevices() async {
    // var url = Uri.parse('http://localhost:8080/devices');
    var url =
        Uri.parse('https://bastion-server-951fbdb64d29.herokuapp.com/devices');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var resData = json.decode(response.body)["data"]["items"] as List;
      var devices = resData.map((i) => Device.fromJSON(i)).toList();
      return devices;
    } else {
      throw Exception('Failed to load lights');
    }
  }

  Future<bool> createDevice() async {
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

  Future<bool> deleteDevice(int id) async {
    // var url = Uri.parse('http://localhost:8080/devices');
    var url = Uri.parse(
        'https://bastion-server-951fbdb64d29.herokuapp.com/devices/${id}');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create devices');
    }
  }

  Future<bool> toggleDevice(Device device, bool toOn) async {
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