import 'package:flutter/foundation.dart' show protected;

import '../screen_controller.dart';

/// This mixin provide a capability to perform data load logic.
/// By using this mixin, a controller will inherit "data", "isLoading" and "error" members
/// and the controller must implement "fetchData" mehtod, then enjoy the logic
/// This class has also refresh method with silence option (refresh data without trigger loader)
mixin DataScreenController<T> on ScreenController {
  /// The loaded data, null if there is no data
  T? data;

  /// "true" while fetching data without silence mode
  bool isLoading = true;

  /// Can by anything, it's the error object in catch block in case of error
  /// hasError is true if this is null (bool get hasError => error != null;)
  dynamic error;

  @override
  @protected
  void onInit() {
    refresh();
  }

  /// A boolean to indicate if there is error
  bool get hasError => error != null;

  /// Call this to trigger data fetching again, if you passe [selence] to true,
  /// then isLoading variable will not get update and the function will just update
  /// data when fetch is complete
  void refresh({silence = false}) {
    if (!isLoading || error != null) {
      isLoading = true;
      error = null;
      if (!silence) updateUI();
    }

    fetchData().then((value) {
      data = value;
    }).catchError((err) {
      error = err;
    }).whenComplete(() {
      isLoading = false;
      updateUI();
    });
  }

  /// Call refresh with selence set to true
  void silentRefresh() => refresh(silence: true);

  /// You must override this method to fetch your screen data
  Future<T> fetchData();
}
