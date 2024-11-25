import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';
import '../models/device.dart';

class WebSocketService with ChangeNotifier {
  late WebSocketChannel _channel;
  final List<Device> _devices = [];

  List<Device> get devices => _devices;

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      // debugPrint('WebSocket connection established to $url');
    } catch (e) {
      // debugPrint('Error while connecting to WebSocket: $e');
      return;
    }

    _channel.stream.listen(
      (message) {
        final data = json.decode(message);
        updateDeviceList(data['devices']);
      },
      onError: (error) {
        // debugPrint('WebSocket Error: $error');
      },
      onDone: () {
        // debugPrint('WebSocket connection closed.');
      },
    );
  }

  void updateDeviceList(List<dynamic> newDevices) {
    _devices.clear();
    _devices.addAll(newDevices.map((device) => Device.fromJSON(device)));
    notifyListeners();
  }

  void disconnect() {
    _channel.sink.close();
  }
}
