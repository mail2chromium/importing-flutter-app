import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:my_capital/controllers/all_shipments_controller.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';

import '../../custom_texts/MontserratText.dart';

class MainShipmentScreen extends GetView<AllShipmentsController> {
  const MainShipmentScreen({Key? key}) : super(key: key);

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
      appBar: CustomAppBar("Shipments"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.035,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            backgroundColor: Color(0xFF0A30D5),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                            onPressed: (BuildContext context) {},
                          ),
                          SlidableAction(
                            backgroundColor: Color(0xFFE30606),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                            onPressed: (BuildContext context) {},
                          ),
                        ],
                      ),
                      child: ListTile(
                        isThreeLine: true,
                        title: MontserratText(
                            "John Doe", 18, Colors.black, FontWeight.bold),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MontserratText("19-05-2022", 14, Colors.black45,
                                FontWeight.normal),
                            MontserratText("Container", 14, Colors.black45,
                                FontWeight.normal),
                            MontserratText("ID: 21", 14, Colors.black45,
                                FontWeight.normal),
                          ],
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MontserratText(
                                "\$2000", 14, Colors.black, FontWeight.bold),
                            MontserratText(
                                "10 KG", 14, Colors.black45, FontWeight.normal),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddShipment,
        child: Icon(Icons.add),
      ),
    );
  }

  void _goToAddShipment() {
    Get.toNamed("/add_shipment");
  }
}
