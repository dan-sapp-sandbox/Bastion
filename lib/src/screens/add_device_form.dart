import 'package:flutter/material.dart';

class AddDeviceForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddDeviceForm({super.key, required this.onAdd});

  @override
  AddDeviceFormState createState() => AddDeviceFormState();
}

class AddDeviceFormState extends State<AddDeviceForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = 'light'; // Default type
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensure the form fits within the modal
          children: [
            TextFormField(
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
                DropdownMenuItem(value: 'switch', child: Text('Switch')),
                DropdownMenuItem(value: 'appliance', child: Text('Appliance')),
              ],
              onChanged: (value) => _type = value!,
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
                  widget.onAdd({
                    'name': _name,
                    'type': _type,
                    'isOn': _isOn,
                  });
                }
              },
              child: const Text('Add Device'),
            ),
          ],
        ),
      ),
    );
  }
}
