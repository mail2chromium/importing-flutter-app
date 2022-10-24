import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_capital/controllers/demand_draft_detail_controller.dart';
import 'package:my_capital/controllers/purchase_demand_controller.dart';
import 'package:my_capital/custom_extensions/date_extension.dart';
import 'package:my_capital/custom_widgets/custom_loader.dart';

import '../../constants/MyColors.dart';
import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../models/purchase_demand_model.dart';

class PurchaseDemandDetailScreen extends GetView<DemandDraftDetailController> {
  // String purchaseDemandId;

  PurchaseDemandDetailScreen({Key? key}) : super(key: key);

  List<PurchaseDemandModel> listOfDemands = [];

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
      appBar: CustomAppBar("Detail: ${Get.arguments}", actions: [
        // IconButton(onPressed: _moreOptions, icon: const Icon(Icons.more_horiz))
        PopupMenuButton<String>(
          onSelected: (value) => _optionSelected(value),
          itemBuilder: (BuildContext context) {
            return {'Export to Excel', 'Import From Excel', 'Create Invoice', 'View Invoice', 'Edit Details'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ]),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder(
                  stream: controller.realtimeDB
                      .listenForPurchaseDemand(Get.arguments),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      DatabaseEvent obj = snapshot.data as DatabaseEvent;
                      List<PurchaseDemandModel> demands = [];
                      listOfDemands = demands;
                      for (var demand in obj.snapshot.children) {
                        var model = purchaseDemandResponseFromJson(
                            json.encode(demand.value));
                        model.id = demand.key;
                        demands.add(model);
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: demands.length,
                        itemBuilder: (context, index) {
                          var demand = demands[index];
                          return _itemDemand(demand);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(color: Colors.black, height: 2);
                        },
                      );
                    } else {
                      return const CustomLoader();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemDemand(PurchaseDemandModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MontserratText(model.model!, 18, accentColor, FontWeight.bold),
          _itemAttributes(
              "Quantity Demanded", model.quantityDemanded.toString()),
          _itemAttributes(
              "Quantity Provided", model.quantityProvided.toString()),
          _itemAttributes("Rate", model.rate.toString()),
          _itemAttributes(
              "Date", DateTime.parse(model.createdAt!).makeFormat()),
          MontserratText(
            "Description",
            18,
            accentColor,
            FontWeight.bold,
            top: 12.0,
          ),
          MontserratText(
              model.description.toString(), 18, accentColor, FontWeight.normal),
        ],
      ),
    );
  }

  Widget _itemAttributes(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MontserratText(key, 16, accentColor, FontWeight.bold),
        MontserratText(value, 16, accentColor, FontWeight.normal),
      ],
    );
  }

  void _optionSelected(String value) {
    switch (value) {
      case "Create Invoice":
        Get.toNamed("/create_invoice", arguments: {"demand_id":Get.arguments, "demand_models": listOfDemands});
        break;
    }
  }
}
