part of 'sample_item_list_screen.dart';


/// You can also use prepared controller for common use case
/// Another ways is to make your controller private using dart part and part of
class _SampleItemListScreenController extends DataListScreenController<SampleItem> {
  _SampleItemListScreenController(super.state);

  @override
  Future<List<SampleItem>> fetchData() {
    return Future.delayed(const Duration(seconds: 3), () {
      return const [SampleItem(1), SampleItem(2), SampleItem(3)];
    });
  }

}
