import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/screens/settings/settings_controller.dart';
import 'src/screens/settings/settings_service.dart';
import 'src/services/websocket_service.dart';

void main() async{
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    ChangeNotifierProvider(
      create: (_) {
        return WebSocketService()..connect('wss://bastion-server-951fbdb64d29.herokuapp.com/devices/ws');
      },
      child: MyApp(settingsController: settingsController),
    ),
  );
}
