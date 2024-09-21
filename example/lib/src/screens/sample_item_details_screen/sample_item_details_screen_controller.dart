part of 'sample_item_details_screen.dart';

class _SampleItemDetailsScreenController extends ScreenController
    with DataScreenController<SampleItem> {
  _SampleItemDetailsScreenController(super.state, this.id);

  final int id;

  @override
  Future<SampleItem> fetchData() {
    // Use your own logic here to get detail
    return Future.delayed(const Duration(seconds: 2), () => SampleItem(id));
  }
}
