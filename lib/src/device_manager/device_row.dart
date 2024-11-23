import 'package:flutter/material.dart';
import 'models/device.dart';

class DeviceTile extends StatelessWidget {
  final Device device;
  final VoidCallback onTurnOn;
  final VoidCallback onTurnOff;
  final VoidCallback delete;

  const DeviceTile({
    super.key,
    required this.device,
    required this.onTurnOn,
    required this.onTurnOff,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade800, // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(
          // Border properties
          color: Colors.deepPurple.shade800,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800, // Shadow color
            blurRadius: 4, // Softness of shadow
            offset: const Offset(2, 2), // Shadow position
          ),
        ],
      ),
      child: GridTile(
        header: Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: onTurnOn,
            child: Center(
              child: Text(
                device.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        footer: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          onPressed: delete,
        ),
        child: const Icon(
          Icons.lightbulb,
          size: 36,
          color: Colors.amber,
        ),
      ),
    );
  }
}
