import 'package:flutter/material.dart';
import '../services/device_service.dart';
import '../models/device.dart';
import '../widgets/bottom_nav_bar.dart';
import 'device_grid.dart';
import './notifications_view.dart';
import './device_mgmt.dart';
import 'device_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DeviceService _deviceService = DeviceService();
  int currentPageIndex = 0;
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

  Future<void> _toggleDevice(Device device, bool toOn) async {
    setState(() {
      _devices = _devices.map((d) {
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
    });

    try {
      var devices = await _deviceService.toggleDevice(device, toOn);
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      setState(() {
        _devices = _devices;
      });
      debugPrint('Error deleting device: $e');
    }
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
      appBar: AppBar(
        title: const Text('Bastion', style: TextStyle(fontSize: 32)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          DeviceGrid(
              devices: _devices,
              onRefresh: _fetchDevices,
              toggleDevice: _toggleDevice),
          const NotificationsView(),
          DeviceMgmt(
              devices: _devices,
              fetchDevices: _fetchDevices,
              addDevice: _addDevice,
              editDevice: _editDevice,
              deleteDevice: _deleteDevice),
        ],
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentPageIndex,
        onItemSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
