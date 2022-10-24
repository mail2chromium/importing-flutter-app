import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/models/cash_model.dart';

import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../helpers/MyToast.dart';

class CashDepositScreen extends StatelessWidget {
  late BuildContext context;
  final _dateController = TextEditingController();
  final db = RealtimeDB();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "amount": null,
    "datetime": null,
    "details": null,
  };

  // CashDepositScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title:
            MontserratText("Cash Deposit", 18, Colors.black, FontWeight.bold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
                          labelText: "Amount",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter amount";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['amount'] = double.parse(value!);
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: "Pick Date Time",
                        ),
                        readOnly: true,
                        onTap: _dateTimePicker,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Pick Date";
                          }
                          return null;
                        },
                        onSaved: (value){
                          _formData['datetime'] = value;
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Details (optional)",
                        ),
                        onSaved: (value){
                          _formData['details'] = value;
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: mediaQueryData.size.width * 0.8,
                    height: 50,
                    child: MyDarkButton("Proceed", _btnCashDeposit))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _dateTimePicker(){
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        onChanged: (dateTime) {},
        onConfirm: (dateTime) {
          _formData['datetime'] = dateTime;
          _dateController.text = dateTime.toString();
        });
  }

  void _btnCashDeposit(){
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        CashModel cashModel = CashModel(
          datetime: _formData["datetime"],
          amount: _formData["amount"],
          details: _formData["details"]
        );

        db.addCash(cashModel);
        Get.back();
        // _realtimeDB.addSupplier(supplierModel);
      } else {
        MyToast("Validation Error");
      }
    } else {
      MyToast("Unknown Error");
    }
  }
}
