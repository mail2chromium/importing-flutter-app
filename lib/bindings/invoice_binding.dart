import 'package:get/get.dart';
import 'package:my_capital/controllers/invoice_controller.dart';

class InvoiceBinding implements Bindings {
  @override
  void dependencies() {
    // Get.replace(PurchaseDemandController());
    Get.replace(InvoiceController());
    // Get.put(InvoiceController());
  }
}
