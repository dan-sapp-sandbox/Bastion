import 'package:flutter/material.dart';
import '../services/device_service.dart';
import '../models/device.dart';
import 'devices/device_grid.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key, required this.devices, required this.updateDevices});
  static const routeName = '/';
  final Future<List<Device>>? devices;
  final _deviceService = DeviceService();
  final Function(List<Device>) updateDevices;
  
  Future<void> _toggleDevice(Device device, bool toOn) async {
    var updatedDevices = await _deviceService.toggleDevice(device, toOn);
    updateDevices(updatedDevices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Device>>(
        future: devices,
        builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No devices available.'));
          } else {
            return DeviceGrid(
              devices: snapshot.data!,
              toggleDevice: _toggleDevice,
            );
          }
        },
      ),
    );
  }
}
