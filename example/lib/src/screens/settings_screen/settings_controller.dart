import 'package:flutter/material.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';

import 'settings_service.dart';

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
