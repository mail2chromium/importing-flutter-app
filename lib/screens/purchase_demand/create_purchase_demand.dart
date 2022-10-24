import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_capital/constants/MyColors.dart';
import 'package:my_capital/controllers/create_demand_draft_controller.dart';
import 'package:my_capital/controllers/purchase_demand_controller.dart';
import 'package:my_capital/custom_extensions/date_extension.dart';
import 'package:my_capital/custom_widgets/custom_progress_dialog.dart';
import 'package:my_capital/models/purchase_demand_model.dart';

import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../helpers/MyToast.dart';

class CreatePurchaseDemand extends GetView<CreatePurchaseDemandController> {
  // const CreatePurchaseDemand({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "model": null,
    "quantity_demanded": null,
    "quantity_provided": 0,
    "rate": 0,
    "description": null,
  };

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
      appBar: CustomAppBar("Create Demand"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => MontserratText("${controller.purchaseDemandId}", 22,
                    accentColor.withOpacity(0.8), FontWeight.bold)),
                StreamBuilder(
                    stream: controller.realtimeDB.listenForPurchaseDemand(
                        controller.purchaseDemandId.value),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        DatabaseEvent obj = snapshot.data as DatabaseEvent;
                        List<PurchaseDemandModel> demands = [];
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
                        return MontserratText("No demand added", 16,
                            accentColor, FontWeight.normal);
                      }
                    })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickFile(mediaQueryData),
        child: Icon(Icons.add),
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
              "Quantity Provided", model.quantityProvided.toString()),
          _itemAttributes(
              "Quantity Demanded", model.quantityDemanded.toString()),
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

  void _pickFile(MediaQueryData mediaQueryData) async {
    Get.dialog(
      Container(
        height: 20,
        padding: const EdgeInsets.all(10.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: _getDataFromExcelFile,
                        child: MontserratText(
                            "Click here to fetch Models from xlsx file",
                            18,
                            accentColor,
                            FontWeight.normal)),
                    DropdownButtonFormField(
                      hint: MontserratText(
                          "Pick Model", 18, Colors.black54, FontWeight.normal),
                      items: ["Model 1", "Model 2"]
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Model is required";
                        }
                        return null;
                      },
                      onChanged: (String? value) {},
                      onSaved: (value) {
                        _formData["model"] = value;
                      },
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.035,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Quantity Demanded",
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Quantity is required";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData["quantity_demanded"] = value;
                      },
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.035,
                    ),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //     labelText: "Quantity Demanded (optional)",
                    //   ),
                    //   keyboardType: const TextInputType.numberWithOptions(
                    //       signed: false, decimal: true),
                    //   onSaved: (value) {
                    //     _formData["quantity_demanded"] = value;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: mediaQueryData.size.height * 0.035,
                    // ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Quantity Provided (optional)",
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      onSaved: (value) {
                        _formData["quantity_provided"] = value;
                      },
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.035,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Rate (optional)",
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      onSaved: (value) {
                        _formData["rate"] = value;
                      },
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.035,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Description is required";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData["description"] = value;
                      },
                    ),
                    SizedBox(
                      height: mediaQueryData.size.height * 0.035,
                    ),
                    Obx(
                      () => controller.isAdding.value
                          ? Container()
                          : SizedBox(
                              width: mediaQueryData.size.width * 0.8,
                              height: 50,
                              child:
                                  MyDarkButton("ADD", _btnCreatePurchaseDemand),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getDataFromExcelFile() {}

  void _btnCreatePurchaseDemand() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        var selectedModel = _formData["model"];
        var quantityDemanded = int.parse(_formData["quantity_demanded"].toString());

        // var quantityDemanded = _formData["quantity_demanded"];
        // if (quantityDemanded == null || quantityDemanded == "") {
        //   quantityDemanded = 0;
        // } else {
        //   quantityDemanded = int.parse(quantityDemanded.toString());
        // }

        var quantityProvided = _formData["quantity_provided"];
        if (quantityProvided == null || quantityProvided == "") {
          quantityProvided = 0;
        } else {
          quantityProvided = int.parse(quantityProvided.toString());
        }
        var rate = _formData["rate"];
        if (rate == null || rate == "") {
          rate = 0;
        } else {
          rate = int.parse(rate.toString());
        }
        var description = _formData["description"];

        var model = PurchaseDemandModel(
            model: selectedModel,
            quantityDemanded: quantityDemanded,
            quantityProvided: quantityProvided,
            rate: rate,
            description: description,
            createdAt: DateTime.now().toString());

        controller.isAdding.value = true;
        if (controller.purchaseDemandId.value != "") {
          controller.realtimeDB
              .addPurchaseDemand(controller.purchaseDemandId.value, model)
              ?.then((value) {
            controller.isAdding.value = false;
            Get.back();
          }).catchError((error) {
            controller.isAdding.value = false;
            MyToast("ERROR: ${error.toString()}");
          });
        } else {
          controller.isAdding.value = false;
          MyToast("ERROR: ID not created");
        }
      } else {
        MyToast("Validation Error");
      }
    } else {
      MyToast("Unknown Error");
    }
  }
}
