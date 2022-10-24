import 'package:my_capital/controllers/add_shipment_controller.dart';
import 'package:get/get.dart';

class AddShipmentBinding implements Bindings {
  @override
  void dependencies() {
    // Get.replace(PurchaseDemandController());
    Get.replace(AddShipmentController());
    // Get.put(InvoiceController());
  }
}
