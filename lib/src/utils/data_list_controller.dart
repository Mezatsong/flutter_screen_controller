import '../screen_controller.dart';
import './data_controller.dart';

abstract class DataListScreenController<T> extends ScreenController
    with DataScreenController<List<T>> {
  DataListScreenController(super.state);

  @override
  List<T> get data => super.data ?? [];
}
