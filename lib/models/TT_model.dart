import 'dart:convert';

TTModel ttModelResponseFromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return TTModel.fromJson(jsonData);
}

class TTModel {
  String? id;
  String? agentId;
  String? currencyCode;
  double? rate;
  double? amount;
  double? currencyBought;
  String? createdAt;

  TTModel(
      {this.id,
      this.agentId,
      this.currencyCode,
      this.rate,
      this.amount,
      this.currencyBought,
      this.createdAt});

  TTModel.fromJson(Map<String, dynamic> parsedJson) {
    agentId = parsedJson['agentId'];
    currencyCode = parsedJson['currencyCode'];
    rate = parsedJson['rate'];
    amount = parsedJson['amount'];
    currencyBought = parsedJson['currencyBought'];
    createdAt = parsedJson['createdAt'];
  }

  toJson() {
    return {
      "agentId": agentId,
      "currencyCode": currencyCode,
      "rate": rate,
      "amount": amount,
      "currencyBought": currencyBought,
      "createdAt": createdAt
    };
  }
}
