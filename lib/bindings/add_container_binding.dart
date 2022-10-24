import 'package:my_capital/controllers/add_container_controller.dart';
import 'package:get/get.dart';

class AddContainerBinding implements Bindings {
  @override
  void dependencies() {
    // Get.replace(PurchaseDemandController());
    Get.replace(AddContainerController());
    // Get.put(InvoiceController());
  }
}