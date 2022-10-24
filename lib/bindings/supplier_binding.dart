import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:my_capital/controllers/supplier_controller.dart';

class SupplierBinding implements Bindings {
  @override
  void dependencies() {
    // Get.replace(PurchaseDemandController());
    Get.put(SupplierController());
  }
}
