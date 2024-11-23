import 'package:flutter/material.dart';
import '../models/device.dart';
import 'device_form.dart';

class DeviceMgmt extends StatefulWidget {
  final List<Device> devices;
  final Function deleteDevice;
  final Function addDevice;
  final Function editDevice;
  final Function fetchDevices;

  const DeviceMgmt(
      {super.key,
      required this.devices,
      required this.deleteDevice,
      required this.editDevice,
      required this.addDevice,
      required this.fetchDevices});

  @override
  State<DeviceMgmt> createState() => _DeviceMgmtState();
}

class _DeviceMgmtState extends State<DeviceMgmt> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.devices.length,
      itemBuilder: (context, index) {
        var device = widget.devices[index];
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
                            await widget.editDevice(deviceData);
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
                  widget.deleteDevice(device.id);
                  widget.fetchDevices();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
