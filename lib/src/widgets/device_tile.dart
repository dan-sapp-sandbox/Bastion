import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceTile extends StatelessWidget {
  final Device device;
  final VoidCallback onTurnOn;
  final VoidCallback onTurnOff;

  const DeviceTile({
    super.key,
    required this.device,
    required this.onTurnOn,
    required this.onTurnOff,
  });

  IconData _getIconForDeviceType(String type) {
    switch (type) {
      case 'light':
        return Icons.lightbulb;
      case 'lock':
        return Icons.lock;
      case 'fan':
        return Icons.air;
      case 'thermostat':
        return Icons.thermostat;
      case 'speaker':
        return Icons.speaker;
      case 'camera':
        return Icons.videocam;
      default:
        return Icons.device_unknown; // Default icon for unknown types
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade800, // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(
          // Border properties
          color: Colors.deepPurple.shade800,
          width: 1,
        ),
      ),
      child: GridTile(
          header: Align(
            alignment: Alignment.center,
            child: Text(
              device.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          child: IconButton(
            icon: Icon(
              _getIconForDeviceType(device.type), // Dynamically fetch icon
              size: 36,
              color: device.isOn ? Colors.amber : Colors.blueGrey,
            ),
            onPressed: device.isOn ? onTurnOff : onTurnOn,
          )),
    );
  }
}
