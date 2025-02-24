import 'package:flutter/material.dart' show protected, BuildContext;
import 'screen_controller_builder.dart';

/// Abstract base class for controller, all screen controller must inerhit this class
/// A wrapper widget (ScreenControllerBuilder) is required for controller to work
/// here is how to use:
/// ```dart
/// ScreenControllerBuilder<ConcretExampleScreenController>(
/// 	create: (state) => ConcretExampleScreenController(state),
/// 	builder: (BuildContext context, ConcretExampleScreenController controller) {
///   	return Text(controller.text); // or anything you want
///   }
/// )
/// ```
abstract class ScreenController {
  /// The state instance of underlaying StatefullWidget, controller need this to update UI
  @protected
  final ScreenControllerBuilderState state;

  const ScreenController(this.state);

  /// Get the underlaying StatefullWidget context (state.context)
  @protected
  BuildContext get context => state.context;

  /// Get the underlaying StatefullWidget mounted (state.mounted)
  @protected
  bool get mounted => state.mounted;

  /// Called immediately after the widget is allocated in memory.
  /// You might use this to initialize something for the controller.
  @protected
  void onInit() {}

  /// Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation events, like snackbar, dialogs, or a new route, or
  /// async request.
  @protected
  void onReady() {}

  /// [onDispose] might be used to dispose resources used by the controller.
  /// Like closing events, or streams before the controller is destroyed.
  /// Or dispose objects that can potentially create some memory leaks,
  /// like TextEditingControllers, AnimationControllers.
  /// Might be useful as well to persist some data on disk.
  @protected
  void onDispose() {}

  /// Call this method to update the UI, it's same as setState
  /// Return true if UI was refreshed, false otherwise (mounted is false by ex.)
  @protected
  bool updateUI([void Function()? fn]) => state.safeSetState(fn);

  /// Call this method to update the UI, it's same as setState(() {}).
  /// Return true if UI was refreshed, false otherwise (mounted is false by ex.)
  @protected
  bool refreshUI() => updateUI();

  @protected
  @override
  String toString() => super.toString();
}
