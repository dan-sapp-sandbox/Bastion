import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../widgets/device_tile.dart';

class DeviceGrid extends StatelessWidget {
  final List<Device> devices;
  final Function toggleDevice;

  const DeviceGrid({super.key, required this.devices, required this.toggleDevice});

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
          onTurnOn: () => toggleDevice(device, true),
          onTurnOff: () => toggleDevice(device, false),
        );
      },
    );
  }
}
