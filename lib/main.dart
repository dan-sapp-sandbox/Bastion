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
        return WebSocketService()..connect('ws://localhost:8080/devices/ws');
      },
      child: MyApp(settingsController: settingsController),
    ),
  );
}
