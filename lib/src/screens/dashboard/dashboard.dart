import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/websocket_service.dart';
import 'device_grid.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final webSocketService = Provider.of<WebSocketService>(context);

    return Scaffold(
      body: DeviceGrid(devices: webSocketService.devices),
    );
  }
}
