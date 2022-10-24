import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:my_capital/controllers/add_shipment_controller.dart';

import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../custom_widgets/custom_appbar.dart';

class AddShipmentScreen extends GetView<AddShipmentController> {
  // const AddShipmentScreen({Key? key}) : super(key: key);
  late BuildContext context;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "shipment_id": null,
    "date": null,
    "shipper_name": null,
  };

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
      appBar: CustomAppBar("Add Shipment"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.local_shipping),
                    hintText: "Shipment ID",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  onTap: _dateTimePicker,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.date_range),
                    hintText: "Date",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: "Shipper Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  hint: MontserratText(
                      "Delivery Status", 18, Colors.black54, FontWeight.normal),
                  items: {"Delivered", "In Progress"}.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Agent is required";
                    }
                    return null;
                  },
                  onChanged: (String? value) {},
                  onSaved: (value) {

                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  onTap: _countryPicker,
                  decoration: InputDecoration(
                    hintText: "Via",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: mediaQueryData.size.width * 0.8,
                    height: 50,
                    child: MyDarkButton("Create Shipment", _btnCreateShipment))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContainer,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _btnCreateShipment(){

  }

  void _dateTimePicker() {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        onChanged: (dateTime) {}, onConfirm: (dateTime) {
      // _formData['datetime'] = dateTime;
      // _dateController.text = dateTime.toString();
    });
  }

  void _countryPicker(){
    showCountryPicker(
      context: context,
      showPhoneCode: false, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
      },
    );
  }

  void _addContainer() {
    Get.toNamed("/add_container");
  }
}
