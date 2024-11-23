import '../settings/settings_view.dart';
// import 'sample_item.dart';
// import 'sample_item_details_view.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/device.dart';
import 'bottom_nav_bar.dart';
import 'device_row.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/';
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late Future<List<Device>> listDevices;
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    listDevices = fetchDevices();
    // createDevice();
  }

  Future<List<Device>> fetchDevices() async {
    // var url = Uri.parse('http://localhost:8080/devices');
    var url =
        Uri.parse('https://bastion-server-951fbdb64d29.herokuapp.com/devices');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var resData = json.decode(response.body)["data"]["items"] as List;
      var devices = resData.map((i) => Device.fromJSON(i)).toList();
      return devices;
    } else {
      throw Exception('Failed to load lights');
    }
  }

  Future<bool> createDevice() async {
    // var url = Uri.parse('http://localhost:8080/devices');
    var url =
        Uri.parse('https://bastion-server-951fbdb64d29.herokuapp.com/devices');
    var newDevice = {'name': 'Front Door', 'type': 'lock'};
    var payload = json.encode(newDevice);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: payload,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create devices');
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
      return true;
    } else {
      throw Exception('Failed to create devices');
    }
  }

  Future<bool> toggleDevice(Device device, bool toOn) async {
    return true;
  }

  Widget _buildBody() {
    switch (currentPageIndex) {
      case 0:
        return FutureBuilder<List<Device>>(
          future: listDevices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var devices = snapshot.data as List<Device>;
              return GridView.builder(
                padding: const EdgeInsets.all(2),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1, // Adjust based on the design
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  var device = devices[index];
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
        body: _buildBody(),
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
