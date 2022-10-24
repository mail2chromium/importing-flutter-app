import 'package:get/get.dart';
import 'package:my_capital/controllers/purchase_demand_controller.dart';

class PurchaseDemandBinding implements Bindings {
  @override
  void dependencies() {
    Get.replace(PurchaseDemandController());
    // Get.put(PurchaseDemandController());
  }

}

