import 'package:flutter/material.dart';

class ChangeLogRow extends StatelessWidget {
  const ChangeLogRow(
      {super.key, required this.formattedDate, required this.text});

  final String formattedDate, text;
  final String changeType = "add";

  Icon _getIconForDeviceType(String type) {
    switch (type) {
      case 'add':
        return const Icon(Icons.add_circle_outline, color: Colors.green);
      case 'edit':
        return const Icon(Icons.add_circle_outline, color: Colors.blue);
      case 'delete':
        return const Icon(Icons.add_circle_outline, color: Colors.red);
      default:
        return const Icon(Icons.add_circle_outline, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          _getIconForDeviceType(changeType),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
