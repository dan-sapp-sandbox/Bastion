import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/device_service.dart';
import 'device_form.dart';

class DeviceMgmt extends StatefulWidget {
  const DeviceMgmt({super.key});
  static const routeName = '/devices';
  @override
  State<DeviceMgmt> createState() => _DeviceMgmtState();
}

class _DeviceMgmtState extends State<DeviceMgmt> {
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

  Future<void> _addDevice(Device newDevice) async {
    var oldDevices = _devices;
    setState(() {
      _devices.add(newDevice);
    });

    try {
      var devices = await _deviceService.addDevice(newDevice);
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      setState(() {
        _devices = oldDevices;
      });
      debugPrint('Error editing device: $e');
    }
  }

  Future<void> _editDevice(Device newDevice) async {
    setState(() {
      _devices = _devices.map((d) {
        if (d.id == newDevice.id) {
          return newDevice;
        }
        return d;
      }).toList();
    });

    try {
      var devices = await _deviceService.editDevice(newDevice);
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      setState(() {
        _devices = _devices;
      });
      debugPrint('Error editing device: $e');
    }
  }

  Future<void> _deleteDevice(int id) async {
    setState(() {
      _devices = _devices.where((d) => d.id != id).toList();
    });

    try {
      var devices = await _deviceService.deleteDevice(id);
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      setState(() {
        _devices = _devices;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          var device = _devices[index];
          return ListTile(
            title: Text(device.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext modalContext) {
                        return Padding(
                          padding: MediaQuery.of(modalContext).viewInsets,
                          child: DeviceForm(
                            device: device,
                            onAdd: (deviceData) async {},
                            onEdit: (deviceData) async {
                              final navigator = Navigator.of(modalContext);
                              await _editDevice(deviceData);
                              if (mounted) {
                                navigator.pop();
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outlined, color: Colors.red),
                  onPressed: () {
                    _deleteDevice(device.id);
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: DeviceForm(
                    onEdit: (deviceData) async {},
                    onAdd: (deviceData) async {
                      final navigator = Navigator.of(context);
                      await _addDevice(deviceData);
                      navigator.pop();
                      _fetchDevices();
                    }),
              );
            },
          );
        },
        tooltip: 'Add Device',
        backgroundColor: Colors.blue, // Set background color for the FAB
        shape: const CircleBorder(),
        child: const Icon(Icons.add,
            color: Colors.white), // Set background color directly on the FAB
      ),
    );
  }
}
