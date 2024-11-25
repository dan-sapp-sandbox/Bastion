import 'package:flutter/material.dart';
import '../../models/device.dart';
import 'device_tile.dart';
import '../../services/device_service.dart';

class DeviceGrid extends StatelessWidget {
  final List<Device> devices;

  DeviceGrid({super.key, required this.devices});

  final DeviceService _deviceService = DeviceService();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        var device = devices[index];
        return DeviceTile(
          device: device,
          onTurnOn: () => _deviceService.toggleDevice(device, true),
          onTurnOff: () => _deviceService.toggleDevice(device, false),
        );
      },
    );
  }
}
