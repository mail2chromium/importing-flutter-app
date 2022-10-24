import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/models/supplier_model.dart';

class SupplierController extends GetxController {
  var allSuppliers = <SupplierModel>[].obs;
  var db = RealtimeDB();
  var showLoader = false.obs;

  @override
  void onInit() {
    fetchAllSuppliers();
    super.onInit();
  }

  Future<void> fetchAllSuppliers() async {
    showLoader.value = true;
    var suppliers = await db.getAllSuppliers();
    showLoader.value = false;
    allSuppliers.value = suppliers;
    return;
  }

  void addCurrency(String supplierId, String currencyCode){
    db.addSupplierCurrency(supplierId, currencyCode);
  }
}
