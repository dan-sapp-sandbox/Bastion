import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/dashboard.dart';
import 'screens/devices/device_mgmt.dart';
import 'screens/change_log/change_log.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/settings/settings_controller.dart';
import 'screens/settings/settings_view.dart';
import 'models/change_log.dart';
import 'models/device.dart';
import 'services/change_log_service.dart';
import 'services/device_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;
  bool _isLoading = false;

  final ChangeLogService _changeLogService = ChangeLogService();
  Future<List<ChangeLogEntry>>? _changeLog;

  final DeviceService _deviceService = DeviceService();
  Future<List<Device>>? _devices;

  @override
  void initState() {
    super.initState();
    _changeLog = _fetchChangeLogs();
    _fetchDevices();
  }

  Future<List<ChangeLogEntry>> _fetchChangeLogs() async {
    setState(() {
      _isLoading = true;
    });
    var logs = await _changeLogService.fetchChangeLog();
    setState(() {
      _isLoading = false;
    });
    return logs;
  }

  Future<void> _fetchDevices() async {
    var devices = await _deviceService.fetchDevices();
    setState(() {
      _devices = Future.value(devices);
    });
  }

  void updateDevices(devices) {
    setState(() {
      _devices = Future.value(devices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          onGenerateTitle: (BuildContext context) => 'Bastion',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,
          initialRoute: Dashboard.routeName,
          onGenerateRoute: (RouteSettings routeSettings) {
            switch (routeSettings.name) {
              case SettingsView.routeName:
                return MaterialPageRoute(
                  builder: (_) => SettingsView(
                    controller: widget.settingsController,
                  ),
                );
              case Dashboard.routeName:
                return MaterialPageRoute(
                  builder: (_) =>
                      Dashboard(devices: _devices, updateDevices: updateDevices),
                );
              case DeviceMgmt.routeName:
                return MaterialPageRoute(
                    builder: (_) =>
                        DeviceMgmt(devices: _devices, updateDevices: updateDevices));
              case ChangeLogPage.routeName:
                return MaterialPageRoute(
                    builder: (_) => ChangeLogPage(changeLog: _changeLog));
              default:
                return MaterialPageRoute(
                    builder: (_) =>
                        Dashboard(devices: _devices, updateDevices: updateDevices));
            }
          },
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Bastion', style: TextStyle(fontSize: 32)),
            ),
            body: Stack(
              children: [
                IndexedStack(
                  index: currentPageIndex,
                  children: [
                    Dashboard(devices: _devices, updateDevices: updateDevices),
                    DeviceMgmt(devices: _devices, updateDevices: updateDevices),
                    ChangeLogPage(changeLog: _changeLog),
                    ChangeLogPage(changeLog: _changeLog),
                    SettingsView(
                      controller: widget.settingsController,
                    ),
                  ],
                ),
                if (_isLoading) // Display loading indicator when loading
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: currentPageIndex,
              onItemSelected: (index) async {
                if (index == 0 || index == 1) {
                  _fetchDevices();
                } else if (index == 2 || index == 3) {
                  _changeLog = _fetchChangeLogs();
                }
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
