import 'package:flutter/material.dart';

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({super.key});
  static const routeName = '/routines';

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {

  @override
  Widget build(BuildContext context) {

    return const Scaffold(body: Center(child: Text('No routines available.')));
  }
}
