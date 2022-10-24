import 'package:get/get.dart';

import '../controllers/all_shipments_controller.dart';

class AllShipmentsBinding implements Bindings {
  @override
  void dependencies() {
    // Get.replace(PurchaseDemandController());
    Get.replace(AllShipmentsController());
    // Get.put(InvoiceController());
  }
}
