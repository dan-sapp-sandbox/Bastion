import '../settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/device.dart';
import 'bottom_nav_bar.dart';
import 'device_tile.dart';
// import 'api.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/';
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  bool _isLoading = true;
  late Future<List<Device>> listDevices;
  List<Device> _devices = [];
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    listDevices = fetchDevices();
  }

  Future<List<Device>> fetchDevices() async {
    var url =
        Uri.parse('https://bastion-server-951fbdb64d29.herokuapp.com/devices');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body)["data"]["items"] as List;
        var devices = resData.map((i) => Device.fromJSON(i)).toList();

        // Use setState to update the devices list and loading status
        setState(() {
          _devices = devices;
          _isLoading = false; // Hide loading indicator after fetching
        });
        return devices;
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      return [];
      // Handle the error (maybe show a message to the user)
      // print('Error fetching devices: $error');
    }
  }

  Future<bool> deleteDevice(int id) async {
    // var url = Uri.parse('http://localhost:8080/devices');
    var url = Uri.parse(
        'https://bastion-server-951fbdb64d29.herokuapp.com/devices/${id}');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      fetchDevices();
      return true;
    } else {
      throw Exception('Failed to create devices');
    }
  }

  Future<bool> toggleDevice(Device device, bool toOn) async {
    var url = Uri.parse(
        'https://bastion-server-951fbdb64d29.herokuapp.com/devices/${device.id}');
    var updatedDevice = {
      "id": device.id,
      "name": device.name,
      "type": device.type,
      "isOn": toOn,
    };
    var payload = json.encode(updatedDevice);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: payload,
    );

    if (response.statusCode == 200) {
      fetchDevices();
      return true;
    } else {
      throw Exception('Failed to toggle device state: ${response.body}');
    }
  }

  Widget _buildBody() {
    switch (currentPageIndex) {
      case 0:
        return FutureBuilder<List<Device>>(
          future: listDevices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // var devices = snapshot.data as List<Device>;
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1, // Adjust based on the design
                ),
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  var device = _devices[index];
                  return DeviceTile(
                    device: device,
                    onTurnOn: () => toggleDevice(device, true),
                    onTurnOff: () => toggleDevice(device, false),
                    delete: () => deleteDevice(device.id),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      case 1:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications, size: 64, color: Colors.amber),
              SizedBox(height: 16),
              Text('No new notifications'),
            ],
          ),
        );
      case 2:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.devices, size: 64, color: Colors.blue),
              SizedBox(height: 16),
              Text('Device Management Section'),
            ],
          ),
        );
      default:
        return const Center(
          child: Text('Page not found'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bastion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_sharp),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator()) // Loading spinner
            : _buildBody(),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentPageIndex,
          onItemSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ));
  }
}
