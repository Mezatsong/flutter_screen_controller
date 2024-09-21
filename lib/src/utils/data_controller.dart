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
  void onInit() {
    refresh();
  }

  bool get hasError => error != null;

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

  void silentRefresh() => refresh(silence: true);

  Future<T> fetchData();
}
