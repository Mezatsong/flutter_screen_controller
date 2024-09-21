import 'package:example/src/models/sample_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';

part 'sample_item_details_screen_controller.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsScreen extends StatelessWidget {
  const SampleItemDetailsScreen({required this.id, super.key});

  final int id;

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: ScreenControllerBuilder<_SampleItemDetailsScreenController>(
        create: (state) => _SampleItemDetailsScreenController(state, id),
        builder: (context, ctrl) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.hasError) {
            return Text(
              'An error occur try again later: ${ctrl.error.toString()}',
            );
          }

          // At this stage, data is not null
          final item = ctrl.data!;

          return Center(
            child: Text(
              'More Information Here About Sample ID: ${item.id}',
            ),
          );
        },
      ),
    );
  }
}
