import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:my_capital/controllers/supplier_controller.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/models/supplier_model.dart';

import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../helpers/MyToast.dart';

class AddSupplierScreen extends GetView<SupplierController> {
  BuildContext? context;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "supplier_name": null,
    "supplier_country": null,
    "supplier_contact": null,
  };

  // final _currencyController = TextEditingController();
  // final _realtimeDB = RealtimeDB();

  // AddSupplierScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    this.context = context;
    switch (mediaQueryData.orientation) {
      case Orientation.portrait:
        return _mainBody(mediaQueryData, Orientation.portrait);
      case Orientation.landscape:
        return _mainBody(mediaQueryData, Orientation.landscape);
    }
  }

  Widget _mainBody(MediaQueryData mediaQueryData, Orientation orientation) {
    return Scaffold(
      appBar: CustomAppBar("Add Supplier"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Supplier Name",
                            contentPadding: EdgeInsets.only(top: -8.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Supplier name is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['supplier_name'] = value;
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Supplier Country",
                            contentPadding: EdgeInsets.only(top: -8.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Supplier Country is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData["supplier_country"] = value;
                        }
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Supplier Contact Number",
                            contentPadding: EdgeInsets.only(top: -8.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Supplier Contact Number is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['supplier_contact'] = value;
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                    ],
                  ),
                ),
                Container(
                    width: mediaQueryData.size.width * 0.8,
                    height: 50,
                    child: MyDarkButton("Add Supplier", _btnAddSupplier))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _currencyPicker(BuildContext context) {
  //   showCurrencyPicker(
  //     context: context,
  //     showFlag: true,
  //     showCurrencyName: true,
  //     showCurrencyCode: true,
  //     showSearchField: true,
  //     onSelect: (Currency currency) {
  //       _formData['supplier_currency'] = currency.code;
  //       _currencyController.text = currency.name;
  //     },
  //   );
  // }

  void _btnAddSupplier() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        SupplierModel supplierModel = SupplierModel(
            name: _formData['supplier_name'],
            country: _formData['supplier_country'],
            contact: _formData['supplier_contact']);

        controller.db.addSupplier(supplierModel);
      } else {
        MyToast("Validation Error");
      }
    } else {
      MyToast("Unknown Error");
    }
  }
}
