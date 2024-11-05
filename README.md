<p align="center">
  <img src="https://raw.githubusercontent.com/Mezatsong/flutter_screen_controller/main/demo.gif?sanitize=true"/>
</p>
<h1 align="center"> 
  Easy ways to separe logic from UI in single screen
</h1>

**MOTIVATION:** We have setState with StatefullWidget but as a drawback, the logic of our screen is mixed with the presentation code, this package is here to provide a solution to this problem, giving the ability to separate the logic of the UI for each screen.

## 🎖 Features

For each controller, you can use these methods

- **onInit**: perform early initialization (same like initState),
- **onReady**: perform initialization that need to update ui (like data fetching)
- **onDispose**: dispose resources (same like onDispose)
- **updateUI**: exatly what setState do, but you can call it without parameters

Additionnaly, you have these benefits:

- ❤️ Separating the logic from the UI
- ↩️ Refresh just the part of the screen that's needed
- 🔌 You can have multiple controllers for the same screen with separate logic
- 🔌 You can inherit logic from another screen
- 💾 You can make logic parts that you reuse in your screens
- ⚡ No constraints, there's nothing to stop you using StatefullWidget and ScreenController at the same time.
- 🚀 Some predefined controllers are already available, like the one that does what's on the demo.
- 🛡️ Null safety

## 🔩 Installation

```bash
flutter pub add flutter_screen_controller
```

OR add this to your `pubspec.yaml` file

```yaml
dependencies:
  flutter_screen_controller: <last_version>
```

### ⚡️ Import

```dart
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
```

## 🎮 How To Use

First create your controller, here is a sample

`SettingsController`

```dart
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
    refreshUI();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform screen a change has occurred.
    refreshUI();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
```

Then use it in your screen

`SettingsController`

```dart
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
        // Glue the SettingsController.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the portion of screen wrapped by the controller.
        child: ScreenControllerBuilder( // <----- Don't forget wrapper widget
          create: SettingsController.new, // <---- Add your controller here
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

```

[**Full project example**](https://github.com/Mezatsong/flutter_screen_controller/blob/main/example)

## 🐛 Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is
missing a feature, please raise a ticket on Github and I'll look into it.
Pull request are also welcome.

## ❤️ Donations

If you find this project useful, and would like to support further development and ongoing maintenance, please consider donating.

<p align="center">
  <a href="https://www.buymeacoffee.com/mezatsong" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
</p>
