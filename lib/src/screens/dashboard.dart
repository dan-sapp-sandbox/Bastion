import 'package:flutter/material.dart';
import '../services/device_service.dart';
import '../models/device.dart';
import 'devices/device_grid.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.devices});
  static const routeName = '/';
  final Future<List<Device>>? devices;

  Future<void> _toggleDevice(Device device, bool toOn, DeviceService deviceService) async {
    try {
      deviceService.toggleDevice(device, toOn);
      // var updatedDevices = await _deviceService.toggleDevice(device, toOn);
      // Since it's a StatelessWidget, the updated devices would need to be passed down as new data
      // No need to use setState here, instead pass updated data from parent
    } catch (e) {
      debugPrint('Error toggling device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Device>>(
        future: devices, // The devices Future passed to the widget
        builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No devices available.'));
          } else {
            return DeviceGrid(
              devices: snapshot.data!,
              onRefresh: () {
                // The logic for refreshing devices will now have to happen outside of this widget
                // In a parent widget that can trigger a rebuild with new data
              },
              toggleDevice: (device, toOn) {
                // Call the toggleDevice function here with the necessary service
                final _deviceService = DeviceService();  // Assuming DeviceService is a singleton or can be instantiated
                _toggleDevice(device, toOn, _deviceService);
              },
            );
          }
        },
      ),
    );
  }
}
