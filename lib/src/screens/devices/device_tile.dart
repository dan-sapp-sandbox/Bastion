import 'package:flutter/material.dart';
import '../../models/device.dart';

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
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridTile(
        child: InkWell(
          onTap: device.isOn ? onTurnOff : onTurnOn,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  _getIconForDeviceType(device.type),
                  size: 28,
                  color: device.isOn ? Colors.amber : Colors.blueGrey,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    device.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
