import 'package:get/get.dart';
import 'package:my_capital/controllers/demand_draft_detail_controller.dart';

class DemandDraftDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.replace(DemandDraftDetailController());
  }

}