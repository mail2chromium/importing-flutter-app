import 'package:my_capital/models/purchase_demand_model.dart';

class ItemInvoiceModel {
  PurchaseDemandModel? demand;
  double weightPerItem = 0;
  double totalCost = 0;
  double totalWeight = 0;
  double expectedRsPerKg = 0;
  double totalExpectedRsPerKg = 0;
  double expectedKharcha = 0;
  double totalExpectedKharcha = 0;
  double expectedGharPhonch = 0;
  double totalExpectedGharPhonch = 0;

  toJson() {
    return {
      "weightPerItem": weightPerItem,
      "totalCost": totalCost,
      "totalWeight": totalWeight,
      "expectedRsPerKg": expectedRsPerKg,
      "totalExpectedRsPerKg": totalExpectedRsPerKg,
      "expectedKharcha": expectedKharcha,
      "totalExpectedKharcha": totalExpectedKharcha,
      "expectedGharPhonch": expectedGharPhonch,
      "totalExpectedGharPhonch": totalExpectedGharPhonch
    };
  }
}
