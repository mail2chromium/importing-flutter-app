import 'package:get/get.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/models/currency_model.dart';
import 'package:my_capital/models/item_invoice_model.dart';
import 'package:my_capital/models/supplier_model.dart';

class InvoiceController extends GetxController {

  var realTimeDB = RealtimeDB();
  String? purchaseDemandId;
  var supplierList = <SupplierModel>[].obs;
  var selectedSupplierCurrencies = <SupplierCurrency>[].obs;
  var selectedSupplierCurrency = SupplierCurrency().obs;
  var invoiceItems = <ItemInvoiceModel>[].obs;
  var loading = false.obs;


  @override
  void onInit() {
    print("GOT ARGUMENTS: ${Get.arguments}");
    Map<String, dynamic> map = Get.arguments;
    purchaseDemandId = map["demand_id"];
    for (var data in map["demand_models"]) {
      var item = ItemInvoiceModel();
      item.demand = data;
      invoiceItems.add(item);
    }
    _getAllSuppliers();
    super.onInit();
  }

  void _getAllSuppliers() async {
    loading.value = true;
    supplierList.value = await realTimeDB.getAllSuppliers();
    loading.value = false;
  }
}