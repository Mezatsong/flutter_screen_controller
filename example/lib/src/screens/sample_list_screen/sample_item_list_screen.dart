import 'package:flutter/material.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import '../settings_screen/settings_screen.dart';
import '../sample_item_details_screen/sample_item_details_screen.dart';
import '../../models/sample_item.dart';

// You can use this technique to make your controller private to your screen
part 'sample_item_list_screen_controller.dart';

/// Displays a list of SampleItems.
class SampleItemListScreen extends StatelessWidget {
  const SampleItemListScreen({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
      ),
      // Wrap your screen with ScreenControllerBuilder
      // and pass your controller
      body: ScreenControllerBuilder(
        create: _SampleItemListScreenController.new,
        builder: (context, ctrl) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.hasError) {
            return Text(
              'An error occur try again later: ${ctrl.error.toString()}',
            );
          }

          // There is no error and isLoading is false, then we have data
          return ListView.builder(
            restorationId: 'sampleItemListSampleItemListScreen',
            itemCount: ctrl.data.length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text('SampleItem ${ctrl.data[index].id}'),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  SampleItemDetailsScreen.routeName,
                  arguments: ctrl.data[index].id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
