import 'package:flutter/material.dart';
import '../../services/device_service.dart';
import '../../models/device.dart';
import 'device_grid.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.index});
  static const routeName = '/';
  final int index;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Device> _devices = [];

  final DeviceService _deviceService = DeviceService();

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  @override
  void didUpdateWidget(covariant Dashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index == 1 && oldWidget.index != 1) {
      _fetchDevicesAndCompare();
    }
  }

  void updateDevices(devices) {
    setState(() {
      _devices = devices;
    });
  }

  Future<void> _fetchDevicesAndCompare() async {
    final newDevices = await _deviceService.fetchDevices();

    final currentDevices = _devices;
    if (newDevices.length != currentDevices.length) {
      updateDevices(newDevices);
    }
  }

  Future<void> _fetchDevices() async {
    var devices = await _deviceService.fetchDevices();
    setState(() {
      _devices = devices;
    });
  }

  Future<void> _toggleDevice(Device device, bool toOn) async {
    final currentDevices = _devices;
    final optimisticallyUpdatedDevices = currentDevices.map((d) {
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

    updateDevices(optimisticallyUpdatedDevices);

    await _deviceService.toggleDevice(device, toOn);
    // TODO: Handle fail case
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeviceGrid(
        devices: _devices,
        toggleDevice: _toggleDevice,
      ),
    );
  }
}
