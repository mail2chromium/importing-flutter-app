
class CashModel{
  final String? id;
  final String? datetime;
  final double? amount;
  final String? details;

  CashModel({this.id, this.datetime, this.amount = 0.0, this.details});

  toJson() {
    return { "datetime": datetime, "amount": amount, "details": details };
  }
}