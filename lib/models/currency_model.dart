import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

CurrencyModel currencyResponseFromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return CurrencyModel.fromJson(jsonData);
}

class CurrencyModel {
  String? currencyCode;
  String? name;
  String? symbol;
  double? currencyBought;
  double? amount; // in rupees

  CurrencyModel(
      {this.currencyCode = "",
      this.name = "",
      this.symbol = "",
      this.currencyBought = 0.0,
      this.amount = 0.0});

  CurrencyModel.fromJson(Map<String, dynamic> parsedJson) {
    currencyCode = parsedJson['currencyCode'];
    name = parsedJson['name'];
    symbol = parsedJson['symbol'];
    currencyBought = double.parse(parsedJson['currencyBought'].toString());
    amount = double.parse(parsedJson['amount'].toString());
  }

  toJson() {
    return {
      "currencyCode": currencyCode,
      "name": name,
      "symbol": symbol,
      "currencyBought": currencyBought,
      "amount": amount
    };
  }
}
