import '../settings/settings_view.dart';
// import 'sample_item.dart';
// import 'sample_item_details_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/light.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/';
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late Future<List<Light>> listLights;

  @override
  void initState() {
    super.initState();
    listLights = fetchLights();
  }

  Future<List<Light>> fetchLights() async {
    // var url = Uri.parse('https://openapi.api.govee.com/router/api/v1/user/devices');
    var url = Uri.parse('https://developer-api.govee.com/v1/devices');
    // var apiKey = dotenv.env['API_KEY'] as String;
    var apiKey = 'API_KEY';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Govee-API-Key': apiKey
    };
    final response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var resData = json.decode(response.body)["data"]["devices"] as List;
      var lights = resData.map((i) => Light.fromJSON(i)).toList();
      return lights;
    } else {
      throw Exception('Failed to load lights');
    }
  }

  Future<bool> turnLights(Light light, bool toOn) async {
    try {
      var url = Uri.parse('https://developer-api.govee.com/v1/devices/control');
      // var apiKey = dotenv.env['API_KEY'] as String;
      var apiKey = 'API_KEY';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Govee-API-Key': apiKey
      };
      final response = await http.put(url,
          headers: requestHeaders,
          body: json.encode({
            'device': light.device,
            'model': light.model,
            'cmd': {"name": "turn", "value": toOn ? "on" : "off"},
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to turn off light');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Light Manager'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Light>>(
          future: listLights,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var light = (snapshot.data as List<Light>)[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            light.deviceName,
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
                              turnLights(light, true);
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
                              turnLights(light, false);
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
                  itemCount: (snapshot.data as List<Light>).length);
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
