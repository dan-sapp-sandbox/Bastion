import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/device_service.dart';
import 'device_form.dart';

class DeviceMgmt extends StatelessWidget {
  DeviceMgmt({super.key, required this.devices});
  static const routeName = '/devices';
  final Future<List<Device>>? devices;

  final DeviceService _deviceService = DeviceService();

  Future<void> _addDevice(Device newDevice) async {
    try {
      // Add device through the service
      var newDevices = await _deviceService.addDevice(newDevice);
      // You should notify the parent widget to refresh the list of devices
    } catch (e) {
      debugPrint('Error adding device: $e');
    }
  }

  Future<void> _editDevice(Device newDevice) async {
    try {
      // Edit device through the service
      var newDevices = await _deviceService.editDevice(newDevice);
      // You should notify the parent widget to refresh the list of devices
    } catch (e) {
      debugPrint('Error editing device: $e');
    }
  }

  Future<void> _deleteDevice(int id) async {
    try {
      // Delete device through the service
      var newDevices = await _deviceService.deleteDevice(id);
      // You should notify the parent widget to refresh the list of devices
    } catch (e) {
      debugPrint('Error deleting device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Device>>(
        future: devices, // Using Future passed down to the widget
        builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No devices available.'));
          } else {
            final deviceList = snapshot.data!;

            return ListView.separated(
              itemCount: deviceList.length,
              itemBuilder: (context, index) {
                var device = deviceList[index];
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
              },
              separatorBuilder: (context, index) => const Divider(),
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
