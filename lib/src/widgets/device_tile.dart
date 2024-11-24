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
        return Icons.device_unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade800.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
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
        child: InkWell(
          onTap: device.isOn ? onTurnOff : onTurnOn,
          borderRadius:
              BorderRadius.circular(10), // Match ripple to button shape
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _getIconForDeviceType(device.type), // Dynamically fetch icon
              size: 36,
              color: device.isOn ? Colors.amber : Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
