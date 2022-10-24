import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

//https://stackoverflow.com/questions/61508047/how-to-get-data-from-firebase-realtime-database-into-list-in-flutter

// SupplierModel supplierResponseFromJson(String jsonString) {
//   final jsonData = json.decode(jsonString);
//   return SupplierModel.fromJson(jsonData);
// }

class SupplierModel {
  String? id;
  String? name;
  List<SupplierCurrency>? currencies;
  String? country;
  String? contact;

  SupplierModel(
      {this.id, this.name, this.currencies, this.country, this.contact});

  // SupplierModel.fromJson(Map<String, dynamic> parsedJson) {
  //   name = parsedJson["name"];
  //   country = parsedJson['country'];
  //   contact = parsedJson['contact'];
  //
  //
  //   var key = parsedJson["currency"];
  //
  //   if (key != null && key.length > 0){
  //     for(int i = 0; i < key.length; i++){
  //         var currency = SupplierCurrency.fromJson(key[i]);
  //         currencies?.add(currency);
  //     }
  //   }
  // }

  toJson() {
    return {"name": name, "country": country, "contact": contact};
  }
// Map<dynamic, dynamic> values = needsSnapshot.data.value;
// values.forEach((key, values) {
// needs.add(Need.fromSnapshot(values));
// });
}

class SupplierCurrency {
  String? currencyCode;
  double? credit;

  SupplierCurrency({this.currencyCode, this.credit = 0.0});

  // SupplierCurrency.fromJson(Map<String, dynamic> parsedJson){
  //   currencyCode = parsedJson["currencyCode"];
  //   credit = double.parse(parsedJson["credit"].toString());
  // }

  toJson() {
    return {"currencyCode": currencyCode, "credit": credit};
  }
}
