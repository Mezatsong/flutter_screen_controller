import 'package:flutter/material.dart' show protected, BuildContext;
import 'screen_controller_builder.dart';

abstract class ScreenController {
  @protected
  final ScreenControllerBuilderState state;

  const ScreenController(this.state);

  BuildContext get context => state.context;

  /// Called immediately after the widget is allocated in memory.
  /// You might use this to initialize something for the controller.
  void onInit() {}

  /// Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation events, like snackbar, dialogs, or a new route, or
  /// async request.
  void onReady() {}

  /// [onDispose] might be used to dispose resources used by the controller.
  /// Like closing events, or streams before the controller is destroyed.
  /// Or dispose objects that can potentially create some memory leaks,
  /// like TextEditingControllers, AnimationControllers.
  /// Might be useful as well to persist some data on disk.
  void onDispose() {}

  @protected
  bool updateUI([void Function()? fn]) => state.updateUI(fn);
}
