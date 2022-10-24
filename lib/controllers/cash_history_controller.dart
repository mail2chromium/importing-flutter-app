import 'package:get/get.dart';
import 'package:my_capital/models/cash_model.dart';

import '../firebase/db/realtime_db.dart';

class CashHistoryController extends GetxController {
  var allCash = <CashModel>[].obs;
  var db = RealtimeDB();
  var showLoader = false.obs;

  @override
  void onInit() {
    fetchAllCash();
    super.onInit();
  }


  void fetchAllCash() async {
    showLoader.value = true;
    var cash = await db.getAllCash();
    showLoader.value = false;
    allCash.value = cash;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}