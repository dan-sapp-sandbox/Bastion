import 'package:flutter/material.dart';
import '../../models/device.dart';

class DeviceForm extends StatefulWidget {
  final Function(Device) onAdd;
  final Function(Device) onEdit;
  final Device? device;

  const DeviceForm(
      {super.key, required this.onAdd, required this.onEdit, this.device});

  @override
  DeviceFormState createState() => DeviceFormState();
}

class DeviceFormState extends State<DeviceForm> {
  final _formKey = GlobalKey<FormState>();
  int? _id;
  String _name = '';
  String _type = 'light'; // Default type
  bool _isOn = false;
  bool isAdd = false;

  @override
  void initState() {
    super.initState();
    isAdd = widget.device == null;
    _id = widget.device?.id;
    _name = widget.device?.name ?? '';
    _type = widget.device?.type ?? 'light';
    _isOn = widget.device?.isOn ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Device Name'),
              onSaved: (value) => _name = value ?? '',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a device name';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Device Type'),
              items: const [
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'lock', child: Text('Lock')),
                DropdownMenuItem(value: 'fan', child: Text('Fan')),
                DropdownMenuItem(value: 'thermostat', child: Text('Thermostat')),
                DropdownMenuItem(value: 'speaker', child: Text('Speaker')),
                DropdownMenuItem(value: 'camera', child: Text('Camera')),
              ],
              onChanged: (value) {
                setState(() {
                  _type =
                      value ?? 'light'; // Ensure a valid value is always set
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a device type';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: const Text('Device is On'),
              value: _isOn,
              onChanged: (value) => setState(() => _isOn = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Device device = Device(
                    id: _id ??
                        0, // Use a default id if _id is null (for adding a new device)
                    name: _name,
                    type: _type,
                    isOn: _isOn,
                  );
                  _id == null ? widget.onAdd(device) : widget.onEdit(device);
                }
              },
              child: Text(isAdd ? 'Add Device' : 'Edit Device'),
            ),
          ],
        ),
      ),
    );
  }
}
