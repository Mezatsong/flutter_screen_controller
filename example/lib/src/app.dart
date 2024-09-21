import 'package:flutter/material.dart';

import 'screens/sample_item_details_screen/sample_item_details_screen.dart';
import 'screens/sample_list_screen/sample_item_list_screen.dart';
import 'screens/settings_screen/settings_screen.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case SettingsScreen.routeName:
                return const SettingsScreen();
              case SampleItemDetailsScreen.routeName:
                return SampleItemDetailsScreen(
                  id: routeSettings.arguments as int,
                );
              case SampleItemListScreen.routeName:
              default:
                return const SampleItemListScreen();
            }
          },
        );
      },
    );
  }
}
