import 'package:flutter/material.dart';
import '../services/device_service.dart';
import '../models/device.dart';
import 'devices/device_grid.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/';
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DeviceService _deviceService = DeviceService();
  List<Device> _devices = [];

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    var devices = await _deviceService.fetchDevices();
    setState(() {
      _devices = devices;
    });
  }

  Future<void> _toggleDevice(Device device, bool toOn) async {
    setState(() {
      _devices = _devices.map((d) {
        if (d.id == device.id) {
          return Device(
            id: d.id,
            name: d.name,
            type: d.type,
            isOn: toOn,
          );
        }
        return d;
      }).toList();
    });

    try {
      var devices = await _deviceService.toggleDevice(device, toOn);
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      setState(() {
        _devices = _devices;
      });
      debugPrint('Error deleting device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeviceGrid(
          devices: _devices,
          onRefresh: _fetchDevices,
          toggleDevice: _toggleDevice),
    );
  }
}
