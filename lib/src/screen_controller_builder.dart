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
  const ScreenControllerBuilder({
    required this.create,
    required this.builder,
    super.key,
  });

  /// Controller factory, this function is responsible for controller creation
  /// if you have something to pass to your controller constructor, then do it
  /// in that method, all contructor need state and this factory function already
  /// give you that state, here are some examples:
  ///
  /// In case your controller do not take any additional parameter
  /// ```dart
  /// ScreenControllerBuilder(
  /// 	create: ExampleScreenController.new
  /// 	builder: ...
  /// )
  /// ```
  ///
  /// In case your controller take additionals parameters
  /// ```dart
  /// ScreenControllerBuilder<ExampleScreenController>(
  /// 	create: (state) => ExampleScreenController(state, id: widget.articleId),
  /// 	builder: ...
  /// )
  /// ```
  final T Function(ScreenControllerBuilderState<T>) create;

  /// The builder function to render the part of your screen that need control,
  /// this function expose BuildContext and Controller that you created.
  /// Usage example:
  /// ```dart
  /// ScreenControllerBuilder(
  /// 	create: ExampleScreenController.new
  /// 	builder: (context, controller) {
  /// 		if (controller.isLoading) return CircularProgressIndicator();
  /// 		if (controller.hasError) return Text('An error occur');
  /// 		return ListView.builder(
  /// 			itemCount: controller.data.length,
  /// 			itemBuilder: ...
  /// 		);
  /// 	},
  /// )
  /// ```
  final Widget Function(BuildContext, T) builder;

  @override
  State<StatefulWidget> createState() => ScreenControllerBuilderState<T>();
}

/// Normaly you do not need this, else you want to customize controller behavior
@protected
class ScreenControllerBuilderState<T extends ScreenController>
    extends State<ScreenControllerBuilder<T>> {
  /// The controller instance, it must be inherited fromm ScreenController
  late final T controller;

  @override
  @protected
  void initState() {
    super.initState();
    controller = widget.create(this);
    controller.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.onReady());
  }

  @override
  @protected
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
  @protected
  Widget build(BuildContext context) => widget.builder(context, controller);
}
