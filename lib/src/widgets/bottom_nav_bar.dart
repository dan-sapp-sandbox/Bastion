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
      indicatorColor: Colors.blue,
      selectedIndex: currentIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.history),
          label: 'Changelog',
        ),
        NavigationDestination(
          icon: Icon(Icons.devices),
          label: 'Device Mgmt',
        ),
      ],
    );
  }
}
