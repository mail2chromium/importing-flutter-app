import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/MyDarkButton.dart';

class InventoryMainScreen extends StatelessWidget {
  const InventoryMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    switch (mediaQueryData.orientation) {
      case Orientation.portrait:
        return _mainBody(mediaQueryData, Orientation.portrait);
      case Orientation.landscape:
        return _mainBody(mediaQueryData, Orientation.landscape);
    }
  }

  Widget _mainBody(MediaQueryData mediaQueryData, Orientation orientation) {
    return Scaffold(
      body: Container(
        width: mediaQueryData.size.width,
        height: mediaQueryData.size.height,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: mediaQueryData.size.width,
              margin: const EdgeInsets.only(bottom: 20),
              child: MyDarkButton(
                  "Add new inventory form", _btnAddNewInventoryForm),
            ),
            Container(
              height: 50,
              width: mediaQueryData.size.width,
              margin: const EdgeInsets.only(bottom: 20),
              child: MyDarkButton("Add Inventory", _btnInventory),
            ),
          ],
        ),
      ),
    );
  }

  void _btnAddNewInventoryForm() {
    Get.toNamed('/select_inventory');
  }

  void _btnInventory() {
    Get.toNamed('/add_inventory');
  }
}
