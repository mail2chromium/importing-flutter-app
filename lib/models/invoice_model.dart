
import 'package:my_capital/models/supplier_model.dart';

import 'item_invoice_model.dart';

class InvoiceModel {
  String? demandDraftId;
  String? invoiceNumber;
  SupplierModel? supplier;
  SupplierCurrency? supplierCurrency;
  double expensePerKg = 0.0;
  double exchangeRate = 0.0;
  List<ItemInvoiceModel>? items;

  toJson() {
    return {
      "invoiceNumber": invoiceNumber,
      "supplier": supplier!.id!,
      "supplierCurrency": supplierCurrency!.currencyCode!,
      "expensePerKg": expensePerKg,
      "exchangeRate": exchangeRate,
    };
  }
}