import 'package:flutter/material.dart';
import '../../models/device.dart';
import 'device_tile.dart';
import '../../services/device_service.dart';

class DeviceGrid extends StatelessWidget {
  final List<Device> devices;

  DeviceGrid({super.key, required this.devices});

  final DeviceService _deviceService = DeviceService();

  Map<String, List<Device>> _groupDevicesByRoom(List<Device> devices) {
    final Map<String, List<Device>> groupedDevices = {};
    for (var device in devices) {
      groupedDevices.putIfAbsent(device.room, () => []).add(device);
    }
    return groupedDevices;
  }

  List<Widget> _buildDeviceRows(List<Device> devices) {
    List<Widget> rows = [];

    for (int i = 0; i < devices.length; i += 2) {
      // Take two devices at a time (i and i+1), if available
      var device1 = devices[i];
      var device2 = (i + 1 < devices.length) ? devices[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: DeviceTile(
                  device: device1,
                  onTurnOn: () => _deviceService.toggleDevice(device1, true),
                  onTurnOff: () => _deviceService.toggleDevice(device1, false),
                ),
              ),
              if (device2 == null)
                const Expanded(
                  child: Text(' '),
                ),
              if (device2 != null) const SizedBox(width: 10),
              if (device2 != null)
                Expanded(
                  child: DeviceTile(
                    device: device2,
                    onTurnOn: () => _deviceService.toggleDevice(device2, true),
                    onTurnOff: () =>
                        _deviceService.toggleDevice(device2, false),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _groupDevicesByRoom(devices).entries.map((entry) {
        final room = entry.key;
        final devices = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                room,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Build rows of 2 devices each
            ..._buildDeviceRows(devices),
          ],
        );
      }).toList(),
    );
  }
}
