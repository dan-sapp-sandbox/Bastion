import 'package:flutter/material.dart';
import '../services/device_service.dart';
import '../models/device.dart';
import 'devices/device_grid.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.index});
  static const routeName = '/';
  final int index;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<List<Device>>? _devices;
  final _deviceService = DeviceService();

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  @override
  void didUpdateWidget(covariant Dashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if index has changed
    if (widget.index != oldWidget.index) {
      _fetchDevices();  // Trigger the device fetch on index change
    }
  }

  Future<void> _fetchDevices() async {
    var devices = await _deviceService.fetchDevices();
    updateDevices(devices);
  }

  void updateDevices(devices) {
    setState(() {
      _devices = Future.value(devices);
    });
  }

  Future<void> _toggleDevice(Device device, bool toOn) async {
    var updatedDevices = await _deviceService.toggleDevice(device, toOn);
    updateDevices(updatedDevices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Device>>(
        future: _devices,
        builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No devices available.'));
          } else {
            return DeviceGrid(
              devices: snapshot.data!,
              toggleDevice: _toggleDevice,
            );
          }
        },
      ),
    );
  }
}
