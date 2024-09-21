import '../screen_controller.dart';
import './data_controller.dart';

/// This is same as [DataScreenController], except that it is specialized for list
/// T is the type of list item, so if T is String, then list will be type of List<String>
abstract class DataListScreenController<T> extends ScreenController
    with DataScreenController<List<T>> {
  DataListScreenController(super.state);

  /// In list data is not nullable but empty is there is no element
  @override
  List<T> get data => super.data ?? [];
}
