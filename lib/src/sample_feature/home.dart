import '../settings/settings_view.dart';
// import 'sample_item.dart';
// import 'sample_item_details_view.dart';
// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

import 'models/device.dart';

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

  @override
  void initState() {
    super.initState();
    listDevices = getDevices();
  }

  Future<List<Device>> getDevices() async {
    var mockData = [
      {'name': 'test', 'type': 'test'},
      {'name': 'test2', 'type': 'test2'}
    ];
    // return json.decode(mockData);
    var mappedDevices = mockData.map((i) => Device.fromJSON(i as Map<String, dynamic>)).toList();
    return mappedDevices;
  }

  Future<bool> toggleDevice(Device device, bool toOn) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Device Manager'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Device>>(
          future: listDevices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var device = (snapshot.data as List<Device>)[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            device.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.blue),
                              overlayColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Colors.blue.withOpacity(0.04);
                                  }
                                  if (states.contains(WidgetState.focused) ||
                                      states.contains(WidgetState.pressed)) {
                                    return Colors.blue.withOpacity(0.12);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            onPressed: () {
                              toggleDevice(device, true);
                            },
                            child: const Text('Turn On'),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.blue),
                              overlayColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Colors.blue.withOpacity(0.04);
                                  }
                                  if (states.contains(WidgetState.focused) ||
                                      states.contains(WidgetState.pressed)) {
                                    return Colors.blue.withOpacity(0.12);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            onPressed: () {
                              toggleDevice(device, false);
                            },
                            child: const Text('Turn Off'),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: (snapshot.data as List<Device>).length);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
              ),
            );
          },
        ));
  }
}
