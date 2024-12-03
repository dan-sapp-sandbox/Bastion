import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/device.dart';
import '../../services/device_service.dart';
import '../../services/device_websocket_service.dart';
import 'device_form.dart';

class DeviceMgmt extends StatefulWidget {
  const DeviceMgmt({super.key});
  static const routeName = '/devices';

  @override
  State<DeviceMgmt> createState() => _DeviceMgmtState();
}

class _DeviceMgmtState extends State<DeviceMgmt> {
  final DeviceService _deviceService = DeviceService();

  Map<String, List<Device>> _groupDevicesByType(List<Device> devices) {
    final Map<String, List<Device>> groupedDevices = {};
    for (var device in devices) {
      groupedDevices.putIfAbsent(device.type, () => []).add(device);
    }
    return groupedDevices;
  }

  String _getTitle(String type) {
    if (type.isEmpty) return type;

    const typeMap = {
      'light': "Lights",
      'fan': "Fans",
      'lock': "Locks",
      'sensor': "Sensors",
      'camera': "Cameras",
    };

    return typeMap[type] ?? '${type[0].toUpperCase()}${type.substring(1)}s';
  }

  @override
  Widget build(BuildContext context) {
    final webSocketService = Provider.of<DeviceWebSocketService>(context);

    return Scaffold(
      body: webSocketService.devices.isEmpty
          ? const Center(child: Text('No devices available.'))
          : ListView(
              children: _groupDevicesByType(webSocketService.devices)
                  .entries
                  .map((entry) {
                final type = entry.key;
                final devices = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_getTitle(type),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    ...devices.map((device) {
                      return ListTile(
                        title: Text('${device.room}: ${device.name}'),
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
                                          await _deviceService
                                              .editDevice(deviceData);
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
                                _deviceService.deleteDevice(device.id);
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
                    await _deviceService.addDevice(deviceData);
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
