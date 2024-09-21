import 'package:flutter/material.dart';
import 'screen_controller.dart';

/// A wrapper widget for the controllable part of your screen
/// This class will create a statefullWidget and passe state to the
/// controller, so that the controller will have ability to update the UI
/// This class is also responsible to call controller onInit, onReady
/// and onDispose methods.
/// The controller is unuseful without this class, here is how to use:
/// ```dart
/// ScreenControllerBuilder<ControllerClassName>(
/// 	create: (state) => ControllerClassName(state),
/// 	builder: (BuildContext context, ControllerClassName controller) {
///   	return Text(controller.text); // or anything you want
///   }
/// )
/// ```
class ScreenControllerBuilder<T extends ScreenController>
    extends StatefulWidget {
  final T Function(ScreenControllerBuilderState<T>) create;
  final Widget Function(BuildContext, T) builder;

  const ScreenControllerBuilder({
    required this.create,
    required this.builder,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ScreenControllerBuilderState<T>();
}

class ScreenControllerBuilderState<T extends ScreenController>
    extends State<ScreenControllerBuilder<T>> {
  late final T controller;

  @override
  void initState() {
    super.initState();
    controller = widget.create(this);
    controller.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.onReady());
  }

  @override
  void dispose() {
    controller.onDispose();
    super.dispose();
  }

  /// Call setState if mounted
  /// return true if setState was called
  bool updateUI([void Function()? fn]) {
    if (mounted) {
      if (fn != null) {
        setState(fn);
      } else {
        setState(() {});
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, controller);
}
