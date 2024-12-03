import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onItemSelected,
      indicatorColor: const Color.fromARGB(135, 33, 149, 243),
      selectedIndex: currentIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.devices),
          label: 'Devices',
        ),
        NavigationDestination(
          icon: Icon(Icons.schedule),
          label: 'Routines',
        ),
        NavigationDestination(
          icon: Icon(Icons.list_alt),
          label: 'Event Log',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
