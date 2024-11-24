import 'package:flutter/material.dart';
import 'change_log.dart';

class ChangeLog extends StatefulWidget {
  const ChangeLog({super.key});
  static const routeName = '/change-log';
  @override
  State<ChangeLog> createState() => _ChangeLogState();
}

class _ChangeLogState extends State<ChangeLog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChangeLogPage(),
    );
  }
}
