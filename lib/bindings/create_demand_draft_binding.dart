import 'package:get/get.dart';
import 'package:my_capital/controllers/create_demand_draft_controller.dart';
import 'package:my_capital/controllers/demand_draft_detail_controller.dart';

class CreatePurchaseDemandBinding implements Bindings {
  @override
  void dependencies() {
    Get.replace(CreatePurchaseDemandController());
    // Get.put(PurchaseDemandController());
  }

}