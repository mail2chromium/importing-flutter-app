import 'dart:io';

import 'package:intl/intl.dart';

extension CurrencyExtensions on double {
  String toRupee() {
    return NumberFormat.simpleCurrency(
      name: "PKR",
      decimalDigits: 0,
    ).format(this);
  }

  String toForeignCurrency(String name) {
    return NumberFormat.simpleCurrency(
      name: name,
      decimalDigits: 2,
    ).format(this);
  }
}

extension CurrencyIcon on String {
  // String toCurrencyIcon(String currencyCode){
  //   return NumberFormat.simpleCurrency(
  //     name: currencyCode,
  //     decimalDigits: 0,
  //   ).format(this);

  String toCurrencyIcon() {
    var format = NumberFormat.simpleCurrency(
        locale: Platform.localeName, name: this);
    return format.currencySymbol;
  }
}
