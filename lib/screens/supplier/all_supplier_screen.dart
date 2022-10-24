import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:my_capital/constants/MyColors.dart';
import 'package:my_capital/controllers/supplier_controller.dart';
import 'package:my_capital/custom_extensions/CurrenyExtension.dart';
import 'package:my_capital/custom_widgets/custom_loader.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/models/supplier_model.dart';
import 'package:my_capital/screens/supplier/AddSupplier.dart';

import '../../custom_texts/MontserratText.dart';

class AllSuppliersScreen extends GetView<SupplierController> {
  // const AllSuppliersScreen({Key? key}) : super(key: key);

  // final db = RealtimeDB();
  late BuildContext context;
  final _supplierController = Get.put(SupplierController());

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: MontserratText("Suppliers", 18, Colors.black, FontWeight.bold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
              // Obx(() => _supplierController.showLoader.value ? Text("Loading") : Text("NOT LOADING")),
              Expanded(
                child: Obx(
                  () => _supplierController.showLoader.value
                      ? const CustomLoader()
                      : RefreshIndicator(
                          onRefresh: () {
                            return controller.fetchAllSuppliers();
                          },
                          child: ListView.separated(
                            itemCount: _supplierController.allSuppliers.length,
                            itemBuilder: (BuildContext context, int index) {
                              var supplier =
                                  _supplierController.allSuppliers[index];
                              return _itemSupplier(supplier);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                color: accentColor,
                                height: 2,
                              );
                            },
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Get.to(() => AddSupplierScreen());
            Get.toNamed("/add_supplier");
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget _itemSupplier(SupplierModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          _itemAttributes("Name:", model.name!),
          _itemAttributes("Country:", model.country!),
          _itemAttributes("Contact:", model.contact!),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: model.currencies?.length,
                itemBuilder: (context, index) {
                  var currency = model.currencies?[index];
                  return Row(
                    children: [
                      MontserratText(
                        "${currency!.currencyCode!.toCurrencyIcon()} ",
                        18,
                        Colors.blue,
                        FontWeight.bold,
                      ),
                      MontserratText(
                        "${currency.credit.toString()}",
                        18,
                        Colors.blue,
                        FontWeight.bold,
                        right: 24,
                      ),
                    ],
                  );
                }),
          ),
          TextButton(
              onPressed: () => _addCurrency(model.id!),
              child: MontserratText(
                  "Add Currency", 16, Colors.blue, FontWeight.normal))
        ],
      ),
    );
  }

  Widget _itemAttributes(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: MontserratText(key, 16, accentColor, FontWeight.bold)),
        Flexible(
            child: MontserratText(value, 16, accentColor, FontWeight.normal)),
      ],
    );
  }

  void _addCurrency(String supplierID) {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      showSearchField: true,
      onSelect: (Currency currency) {
        controller.addCurrency(supplierID, currency.code);
      },
    );
  }
}
