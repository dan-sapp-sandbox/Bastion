import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';
import '../models/change_log.dart';

class ChangeLogWebSocketService with ChangeNotifier {
  late WebSocketChannel _channel;
  final List<ChangeLogEntry> _changeLogs = [];

  List<ChangeLogEntry> get changeLogs => _changeLogs;

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      debugPrint('WebSocket connection established to $url');
    } catch (e) {
      debugPrint('Error while connecting to WebSocket: $e');
      return;
    }

    _channel.stream.listen(
      (message) {
        final data = json.decode(message);
        updateChangeLogList(data);
      },
      onError: (error) {
        debugPrint('WebSocket Error: $error');
      },
      onDone: () {
        debugPrint('WebSocket connection closed.');
      },
    );
  }

  void updateChangeLogList(List<dynamic> newChangeLogs) {
    _changeLogs.clear();
    _changeLogs.addAll(newChangeLogs.map((log) => ChangeLogEntry.fromJSON(log)));
    notifyListeners();
  }

  void disconnect() {
    _channel.sink.close();
  }
}
