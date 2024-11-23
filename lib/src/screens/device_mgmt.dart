import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceMgmt extends StatelessWidget {
  final List<Device> devices;
  final Function deleteDevice;
  final Function fetchDevices;

  const DeviceMgmt(
      {super.key,
      required this.devices,
      required this.deleteDevice,
      required this.fetchDevices});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        var device = devices[index];
        return ListTile(
          title: Text(device.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteDevice(device.id);
              fetchDevices();
            },
          ),
        );
      },
    );
  }
}
