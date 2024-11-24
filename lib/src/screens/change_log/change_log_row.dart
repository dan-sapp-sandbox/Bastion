import 'package:flutter/material.dart';

class ChangeLogRow extends StatelessWidget {
  const ChangeLogRow(
      {super.key, required this.formattedDate, required this.text});

  final String formattedDate, text;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Icon(Icons.add_circle_outline, color: Colors.blue),
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
