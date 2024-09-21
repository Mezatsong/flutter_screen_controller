import 'package:flutter/material.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';

void main() {
  runApp(const MyApp());
}

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

/// A placeholder class that represents an entity or model.
class SampleItem {
  const SampleItem(this.id);

  final int id;
}

/// Displays detailed information about a SampleItem.
class SampleItemDetailsScreen extends StatelessWidget {
  const SampleItemDetailsScreen({required this.id, super.key});

  final int id;

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: ScreenControllerBuilder<_SampleItemDetailsScreenController>(
        create: (state) => _SampleItemDetailsScreenController(state, id),
        builder: (context, ctrl) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.hasError) {
            return Text(
              'An error occur try again later: ${ctrl.error.toString()}',
            );
          }

          // At this stage, data is not null
          final item = ctrl.data!;

          return Center(
            child: Text(
              'More Information Here About Sample ID: ${item.id}',
            ),
          );
        },
      ),
    );
  }
}

class _SampleItemDetailsScreenController extends ScreenController
    with DataScreenController<SampleItem> {
  _SampleItemDetailsScreenController(super.state, this.id);

  final int id;

  @override
  Future<SampleItem> fetchData() {
    // Use your own logic here to get detail
    return Future.delayed(const Duration(seconds: 2), () => SampleItem(id));
  }
}

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController extends ScreenController {
  SettingsController(super.state);

  // Make SettingsService a private variable so it is not used directly.
  late final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  // In this method perform early initializations that do not need UI update
  @override
  void onInit() {
    _settingsService = SettingsService();
  }

  // Perform here initializations that will update the UI
  @override
  void onReady() {
    _loadSettings();
  }

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> _loadSettings() async {
    _themeMode = await _settingsService.themeMode();

    // Important! Inform screen a change has occurred.
    updateUI();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform screen a change has occurred.
    updateUI();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }
}

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the portion of screen wrapped by the controller.
        child: ScreenControllerBuilder(
          create: SettingsController.new,
          builder: (context, controller) => DropdownButton<ThemeMode>(
            // Read the selected themeMode from the controller
            value: controller.themeMode,
            // Call the updateThemeMode method any time the user selects a theme.
            onChanged: controller.updateThemeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark Theme'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }
}

/// You can also use prepared controller for common use case
/// Another ways is to make your controller private using dart part and part of
class _SampleItemListScreenController
    extends DataListScreenController<SampleItem> {
  _SampleItemListScreenController(super.state);

  @override
  Future<List<SampleItem>> fetchData() {
    return Future.delayed(const Duration(seconds: 3), () {
      return const [SampleItem(1), SampleItem(2), SampleItem(3)];
    });
  }
}

/// Displays a list of SampleItems.
class SampleItemListScreen extends StatelessWidget {
  const SampleItemListScreen({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
      ),
      // Wrap your screen with ScreenControllerBuilder
      // and pass your controller
      body: ScreenControllerBuilder(
        create: _SampleItemListScreenController.new,
        builder: (context, ctrl) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.hasError) {
            return Text(
              'An error occur try again later: ${ctrl.error.toString()}',
            );
          }

          // There is no error and isLoading is false, then we have data
          return ListView.builder(
            restorationId: 'sampleItemListSampleItemListScreen',
            itemCount: ctrl.data.length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text('SampleItem ${ctrl.data[index].id}'),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  SampleItemDetailsScreen.routeName,
                  arguments: ctrl.data[index].id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
