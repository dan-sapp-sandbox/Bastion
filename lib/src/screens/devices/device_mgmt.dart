import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/device_service.dart';
import 'device_form.dart';

class DeviceMgmt extends StatefulWidget {
  const DeviceMgmt({super.key, required this.index});
  static const routeName = '/devices';
  final int index;

  @override
  State<DeviceMgmt> createState() => _DeviceMgmtState();
}

class _DeviceMgmtState extends State<DeviceMgmt> {
  Future<List<Device>>? _devices;
  final DeviceService _deviceService = DeviceService();

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  @override
  void didUpdateWidget(covariant DeviceMgmt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index == 1 && oldWidget.index != 1) {
      _fetchDevicesAndCompare();
    }
  }

  Future<void> _fetchDevicesAndCompare() async {
    final newDevices = await _deviceService.fetchDevices();

    final currentDevices = await _devices;
    if (currentDevices == null || newDevices.length != currentDevices.length) {
      updateDevices(newDevices);
    }
  }

  Future<void> _fetchDevices() async {
    var devices = await _deviceService.fetchDevices();
    updateDevices(devices);
  }

  void updateDevices(List<Device> devices) {
    setState(() {
      _devices = Future.value(devices);
    });
  }

  Future<void> _addDevice(Device newDevice) async {
    var newDevices = await _deviceService.addDevice(newDevice);
    updateDevices(newDevices);
  }

  Future<void> _editDevice(Device newDevice) async {
    var newDevices = await _deviceService.editDevice(newDevice);
    updateDevices(newDevices);
  }

  Future<void> _deleteDevice(int id) async {
    var newDevices = await _deviceService.deleteDevice(id);
    updateDevices(newDevices);
  }

  Map<String, List<Device>> _groupDevicesByType(List<Device> devices) {
    final Map<String, List<Device>> groupedDevices = {};
    for (var device in devices) {
      groupedDevices.putIfAbsent(device.type, () => []).add(device);
    }
    return groupedDevices;
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
            final deviceList = snapshot.data!;
            final groupedDevices = _groupDevicesByType(deviceList);

            return ListView(
              children: groupedDevices.entries.map((entry) {
                final type = entry.key;
                final devices = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(type,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    ...devices.map((device) {
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
                                      padding: MediaQuery.of(modalContext)
                                          .viewInsets,
                                      child: DeviceForm(
                                        device: device,
                                        onAdd: (deviceData) async {},
                                        onEdit: (deviceData) async {
                                          final navigator =
                                              Navigator.of(modalContext);
                                          await _editDevice(deviceData);
                                          if (navigator.canPop()) {
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
                              icon: const Icon(Icons.delete_outlined,
                                  color: Colors.red),
                              onPressed: () {
                                _deleteDevice(device.id);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(),
                  ],
                );
              }).toList(),
            );
          }
        },
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
                  },
                ),
              );
            },
          );
        },
        tooltip: 'Add Device',
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
