import '../screen_controller.dart';

mixin DataScreenController<T> on ScreenController {
  T? data;
  bool isLoading = true;
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
