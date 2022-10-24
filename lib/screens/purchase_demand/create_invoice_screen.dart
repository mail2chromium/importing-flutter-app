import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:my_capital/controllers/invoice_controller.dart';
import 'package:my_capital/custom_extensions/CurrenyExtension.dart';
import 'package:my_capital/custom_extensions/date_extension.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';
import 'package:my_capital/models/invoice_model.dart';
import 'package:my_capital/models/item_invoice_model.dart';
import 'package:my_capital/models/supplier_model.dart';

import '../../constants/MyColors.dart';
import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../custom_widgets/custom_loader.dart';
import '../../helpers/MyToast.dart';
import '../../models/currency_model.dart';
import '../../models/purchase_demand_model.dart';

class CreateInvoiceScreen extends GetView<InvoiceController> {
  // const CreateInvoiceScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "invoice_number": null,
    "supplier": null,
    "currency_code": null,
    "expense_per_kg": 0.0,
    "exchange_rate": 0.0,
  };

  // List<PurchaseDemandModel> listOfDemands = [];

  @override
  Widget build(BuildContext context) {
    // listOfDemands = Get.arguments;
    // for (var data in Get.arguments) {
    //   var item = ItemInvoiceModel();
    //   item.demand = data;
    //   controller.invoiceItems.add(item);
    // }
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
      appBar: CustomAppBar("Create Invoice"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Invoice Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Invoice number is required";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData["invoice_number"] = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  _getForeignCurrency(orientation, mediaQueryData),
                  const SizedBox(height: 20),
                  _supplierDropDown(),
                  const SizedBox(height: 20),
                  _currencyDropDown(),
                  const SizedBox(height: 20),
                  _expectedExpenseTextField(),
                  const SizedBox(height: 20),
                  _expectedRateTextField(),
                  const SizedBox(height: 20),
                  _items(),
                  Container(
                      width: mediaQueryData.size.width * 0.8,
                      height: 50,
                      child: MyDarkButton("Create Invoice", _btnCreateInvoice))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _getForeignCurrency(
      Orientation orientation, MediaQueryData mediaQueryData) {
    return SizedBox(
      height: orientation == Orientation.portrait
          ? mediaQueryData.size.height * 0.15
          : mediaQueryData.size.height * 0.3,
      child: StreamBuilder(
          stream: controller.realTimeDB.listenForCurrency(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              DatabaseEvent obj = snapshot.data as DatabaseEvent;
              List<CurrencyModel> currencies = [];
              for (var currency in obj.snapshot.children) {
                var model =
                    currencyResponseFromJson(json.encode(currency.value));
                currencies.add(model);
              }
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: currencies.length,
                itemBuilder: (BuildContext context, int index) {
                  var currency = currencies[index];
                  return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                        border: Border.all(color: accentColor, width: 3),
                      ),
                      child: _currencies("${currency.currencyCode}",
                          currency.currencyBought!, currency.amount!));
                },
              );
            } else {
              return const CustomLoader();
            }
          }),
    );
  }

  Widget _currencies(String name, double amount, double pkrAmount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MontserratText("$name: ${amount.toForeignCurrency(name)}", 18,
            Colors.black, FontWeight.bold),
        Container(
          width: 50,
          height: 2,
          color: Colors.black,
          margin: const EdgeInsets.symmetric(vertical: 5),
        ),
        MontserratText(pkrAmount.toRupee(), 14, Colors.black, FontWeight.normal)
      ],
    );
  }

  Widget _supplierDropDown() {
    return Obx(() => controller.loading.value
        ? const CustomLoader()
        : DropdownButtonFormField(
            hint: MontserratText(
                "Pick Supplier", 18, Colors.black54, FontWeight.normal),
            items: controller.supplierList
                .map<DropdownMenuItem<SupplierModel>>((value) {
              return DropdownMenuItem<SupplierModel>(
                value: value,
                child: Text("${value.name}"),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return "Supplier is required";
              }
              return null;
            },
            onChanged: (SupplierModel? value) {
              if (value != null && value.currencies != null) {
                controller.selectedSupplierCurrencies.value = value.currencies!;
                controller.selectedSupplierCurrency.value =
                    value.currencies![0];
              }
            },
            onSaved: (value) {
              _formData["supplier"] = value;
            },
          ));
  }

  Widget _currencyDropDown() {
    return Obx(
      () =>
          // Text("GOT ${controller.selectedSupplierCurrencies.length}")
          Container(
        height: 20,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: controller.selectedSupplierCurrencies.length,
            itemBuilder: (context, index) {
              var value = controller.selectedSupplierCurrencies[index];
              return InkWell(
                onTap: () {
                  _formData["currency_code"] = value;
                  controller.selectedSupplierCurrency.value = value;
                },
                child: Obx(() => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: MontserratText(
                        "${value.currencyCode}",
                        18,
                        accentColor,
                        controller.selectedSupplierCurrency.value == value
                            ? FontWeight.bold
                            : FontWeight.normal))),
              );
            }),
      ),
    );
  }

  Widget _expectedExpenseTextField() {
    return TextFormField(
        decoration: const InputDecoration(
            labelText: "Expense per KG",
            contentPadding: EdgeInsets.only(top: -8.0)),
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "expense is required";
          }
          return null;
        },
        onChanged: (value) {
          _formData["expense_per_kg"] = value;
        });
  }

  Widget _expectedRateTextField() {
    return TextFormField(
        decoration: const InputDecoration(
            labelText: "Exchange Rate",
            contentPadding: EdgeInsets.only(top: -8.0)),
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Exchange Rate";
          }
          return null;
        },
        onChanged: (value) {
          _formData["exchange_rate"] = value;
        });
  }

  Widget _items() {
    return Obx(() => ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.invoiceItems.length,
          itemBuilder: (context, index) {
            var demand = controller.invoiceItems[index];
            // demand.expensePerKg = double.parse(_formData["expense_per_kg"].toString());
            return _itemDemand(demand, index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(color: Colors.black, height: 2);
          },
        ));
  }

  Widget _itemDemand(ItemInvoiceModel model, int index) {
    model.totalCost = model.demand!.rate!.toDouble() *
        model.demand!.quantityProvided!.toDouble();
    model.expectedRsPerKg =
        double.parse(_formData["exchange_rate"].toString()) *
            model.demand!.rate!.toDouble();
    model.totalExpectedRsPerKg =
        model.expectedRsPerKg * model.demand!.quantityDemanded!.toDouble();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MontserratText(
              model.demand!.model!, 18, accentColor, FontWeight.bold),
          _itemAttributes(
              "Quantity Provided", model.demand!.quantityProvided.toString()),
          _itemAttributes("Rate", model.demand!.rate.toString()),
          _itemAttributes("Total Cost", model.totalCost.toString()),
          TextField(
            decoration: const InputDecoration(label: Text("Weight per item")),
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: true),
            onChanged: (String value) {
              var result = double.tryParse(value);
              if (result != null) {
                model.weightPerItem = result;
                model.totalWeight = model.weightPerItem *
                    model.demand!.quantityProvided!.toDouble();
                model.expectedKharcha = model.weightPerItem *
                    double.parse(_formData["expense_per_kg"].toString());
                model.totalExpectedKharcha = model.expectedKharcha *
                    model.demand!.quantityDemanded!.toDouble();
                model.expectedGharPhonch =
                    double.parse(_formData["expense_per_kg"].toString()) *
                        model.expectedKharcha;
                model.totalExpectedGharPhonch = model.expectedGharPhonch =
                    model.demand!.quantityDemanded!.toDouble();
                controller.invoiceItems[index] = model;
              }
            },
          ),
          const SizedBox(height: 20),
          _itemAttributes("Total Weight", model.totalWeight.toString()),
          _itemAttributes("Expected Rs/KG", model.expectedRsPerKg.toString()),
          _itemAttributes(
              "Total Expected Rs/KG", model.totalExpectedRsPerKg.toString()),
          // TextField(
          //   decoration: const InputDecoration(label: Text("Expense per kg")),
          //   keyboardType: const TextInputType.numberWithOptions(
          //       signed: false, decimal: true),
          //   onChanged: (String value) {
          //     var result = double.tryParse(value);
          //     if (result != null) {
          //       model.expensePerKg = result;
          //       model.expectedKharcha = model.weightPerItem * model.expensePerKg;
          //       model.totalExpectedKharcha = model.expectedKharcha * model.demand!.quantityDemanded!.toDouble();
          //       model.expectedGharPhonch = model.expensePerKg * model.expectedKharcha;
          //       model.totalExpectedGharPhonch = model.expectedGharPhonch = model.demand!.quantityDemanded!.toDouble();
          //       controller.invoiceItems[index] = model;
          //     }
          //   },
          // ),
          // const SizedBox(height: 20),
          _itemAttributes("Expected Kharcha", model.expectedKharcha.toString()),
          _itemAttributes(
              "Total Expected Kharcha", model.totalExpectedKharcha.toString()),
          _itemAttributes(
              "Expected Ghar Phonch", model.expectedGharPhonch.toString()),
          _itemAttributes("Total Expected Ghar Phonch",
              model.totalExpectedGharPhonch.toString()),
          _itemAttributes(
              "Date", DateTime.parse(model.demand!.createdAt!).makeFormat()),
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

  void _btnCreateInvoice() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (controller.purchaseDemandId == null) {
          MyToast("Purchase demand unknown!");
          return;
        }
        var invoiceModel = InvoiceModel();
        invoiceModel.demandDraftId = controller.purchaseDemandId;
        invoiceModel.invoiceNumber = _formData["invoice_number"];
        invoiceModel.supplier = _formData["supplier"];
        invoiceModel.supplierCurrency = _formData["currency_code"];
        invoiceModel.expensePerKg = double.parse(_formData["expense_per_kg"].toString());
        invoiceModel.exchangeRate = double.parse(_formData["exchange_rate"].toString());
        invoiceModel.items = controller.invoiceItems;

        controller.realTimeDB.createInvoice(invoiceModel).then((value) {
          MyToast("Created");
        });
      } else {
        MyToast("Validation Error");
      }
    } else {
      MyToast("Unknown Error");
    }
  }
}
