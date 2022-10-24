import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:my_capital/controllers/purchase_demand_controller.dart';
import 'package:my_capital/custom_extensions/date_extension.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';
import 'package:my_capital/models/purchase_demand_model.dart';
import 'package:my_capital/screens/purchase_demand/create_purchase_demand.dart';

import '../../constants/MyColors.dart';
import '../../custom_texts/MontserratText.dart';

class PurchaseDemandScreen extends GetView<PurchaseDemandController> {
  const PurchaseDemandScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    switch (mediaQueryData.orientation) {
      case Orientation.portrait:
        return _mainBody(mediaQueryData, Orientation.portrait, context);
      case Orientation.landscape:
        return _mainBody(mediaQueryData, Orientation.landscape, context);
    }
  }

  Widget _mainBody(MediaQueryData mediaQueryData, Orientation orientation,
      BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Purchase Demand"),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewDemand,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              // SizedBox(
              //   height: mediaQueryData.size.height * 0.035,
              // ),
              Expanded(
                child: Obx(() => RefreshIndicator(
                      onRefresh: () {
                        return controller.fetchAllPurchaseDemands();
                      },
                      child: ListView.builder(
                        itemCount: controller.allPurchaseDemands.length,
                        itemBuilder: (context, index) {
                          var demand = controller.allPurchaseDemands[index];
                          return _itemPurchaseDemand(demand);
                        },
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemPurchaseDemand(PurchaseDemandModel model) {
    return ListTile(
      onTap: () {
        Get.toNamed("/purchase_demand_detail", arguments: model.id);
      },
      title: MontserratText(model.id!, 18, accentColor, FontWeight.bold),
      subtitle: MontserratText(
          DateTime.parse(model.createdAt.toString()).makeFormat(),
          18,
          accentColor,
          FontWeight.normal),
      trailing: MontserratText(
          model.quantityDemanded.toString(), 18, accentColor, FontWeight.normal),
    );
  }

  void _createNewDemand() {
    Get.toNamed("/create_purchase_demand");
  }
}
