import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

PurchaseDemandModel purchaseDemandResponseFromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return PurchaseDemandModel.fromJson(jsonData);
}

class PurchaseDemandModel {
  String? id;
  String? model;
  int? quantityDemanded;
  int? quantityProvided;
  int? rate;
  String? description;
  String? createdAt;

  PurchaseDemandModel(
      {this.id,
      this.model,
      this.quantityDemanded,
      this.quantityProvided,
      this.rate,
      this.description,
      this.createdAt});

  PurchaseDemandModel.fromJson(Map<String, dynamic> parsedJson) {
    model = parsedJson["model"];
    quantityDemanded = parsedJson['quantityDemanded'];
    quantityProvided = parsedJson['quantityProvided'];
    rate = parsedJson['rate'];
    description = parsedJson['description'];
    createdAt = parsedJson['createdAt'];
  }

  toJson() {
    return {
      "model": model,
      "quantityDemanded": quantityDemanded,
      "quantityProvided": quantityProvided,
      "rate": rate,
      "description": description,
      "createdAt": createdAt
    };
  }
}
