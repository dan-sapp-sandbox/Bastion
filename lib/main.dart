import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/screens/settings/settings_controller.dart';
import 'src/screens/settings/settings_service.dart';
import 'src/services/websocket_service.dart';

void main() async{
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  // var url = 'ws://localhost:8080/devices/ws';
  var url = 'wss://bastion-server-951fbdb64d29.herokuapp.com/devices/ws';
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        return WebSocketService()..connect(url);
      },
      child: MyApp(settingsController: settingsController),
    ),
  );
}
