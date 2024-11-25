import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/screens/settings/settings_controller.dart';
import 'src/screens/settings/settings_service.dart';
import 'src/services/device_websocket_service.dart';
import 'src/services/change_log_websocket_service.dart';

void main() async{
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  // var deviceUrl = 'ws://localhost:8080/devices/ws';
  var deviceUrl = 'wss://bastion-server-951fbdb64d29.herokuapp.com/devices/ws';

  // var changeLogUrl = 'ws://localhost:8080/change-log/ws';
  var changeLogUrl = 'wss://bastion-server-951fbdb64d29.herokuapp.com/change-log/ws';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DeviceWebSocketService>(
          create: (_) => DeviceWebSocketService()..connect(deviceUrl),
        ),
        ChangeNotifierProvider<ChangeLogWebSocketService>(
          create: (_) => ChangeLogWebSocketService()..connect(changeLogUrl),
        ),
      ],
      child: MyApp(settingsController: settingsController),
    ),
  );
}
