

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:my_capital/models/TT_model.dart';

import '../firebase/db/realtime_db.dart';

class TTController extends GetxController {
  var allTTs = <TTModel>[].obs;
  var db = RealtimeDB();
  var showLoader = false.obs;

  @override
  void onInit() {
    fetchAllTTs();
    super.onInit();
  }

  void fetchAllTTs() async {
    showLoader.value = true;
    var tt = await db.getAllTTs();
    showLoader.value = false;
    allTTs.value = tt;
  }
}
