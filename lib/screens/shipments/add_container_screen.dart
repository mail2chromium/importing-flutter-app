import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_capital/controllers/add_container_controller.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';

class AddContainerScreen extends GetView<AddContainerController> {
  const AddContainerScreen({Key? key}) : super(key: key);

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
      appBar: CustomAppBar("Add Container"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text("I am text")
            ],
          ),
        ),
      ),
    );
  }
}
