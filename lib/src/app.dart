import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/dashboard.dart';
import 'screens/device_mgmt.dart';
import 'screens/change_log_wrapper.dart';
import 'widgets/bottom_nav_bar.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

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
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
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
              case ChangeLog.routeName:
                return MaterialPageRoute(builder: (_) => const ChangeLog());
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
                const ChangeLog(),
                const ChangeLog(),
                SettingsView(
                  controller: widget.settingsController,
                ),
              ],
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: currentPageIndex,
              onItemSelected: (index) {
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
