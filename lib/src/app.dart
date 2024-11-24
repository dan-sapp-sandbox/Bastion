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
import 'services/change_log_service.dart';

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
  @override
  void initState() {
    super.initState();
    _changeLog = _fetchChangeLogs();
  }

  int currentPageIndex = 0;

  final ChangeLogService _changeLogService = ChangeLogService();
  Future<List<ChangeLogEntry>>? _changeLog;
  Future<List<ChangeLogEntry>> _fetchChangeLogs() async {
    return await _changeLogService.fetchChangeLog();
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
                return MaterialPageRoute(builder: (_) => const Dashboard());
              case ChangeLogPage.routeName:
                return MaterialPageRoute(
                    builder: (_) => ChangeLogPage(changeLog: _changeLog));
              case DeviceMgmt.routeName:
                return MaterialPageRoute(builder: (_) => const DeviceMgmt());
              default:
                return MaterialPageRoute(builder: (_) => const Dashboard());
            }
          },
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Bastion', style: TextStyle(fontSize: 32)),
            ),
            body: IndexedStack(
              index: currentPageIndex,
              children: [
                const Dashboard(),
                const DeviceMgmt(),
                ChangeLogPage(changeLog: _changeLog),
                ChangeLogPage(changeLog: _changeLog),
                SettingsView(
                  controller: widget.settingsController,
                ),
              ],
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: currentPageIndex,
              onItemSelected: (index) async {
                switch (index) {
                  case 0:
                    //get devices
                    setState(() {
                      currentPageIndex = index;
                    });
                    break;
                  case 1:
                    //get devices
                    setState(() {
                      currentPageIndex = index;
                    });
                    break;
                  case 2:
                    //get routines
                    final newLogs = await _fetchChangeLogs();
                    setState(() {
                      currentPageIndex = index;
                      _changeLog = Future.value(newLogs);
                    });
                    break;
                  case 3:
                    final newLogs = await _fetchChangeLogs();
                    setState(() {
                      currentPageIndex = index;
                      _changeLog = Future.value(newLogs);
                    });
                    break;
                  default:
                    setState(() {
                      currentPageIndex = index;
                    });
                }
              },
            ),
          ),
        );
      },
    );
  }
}
