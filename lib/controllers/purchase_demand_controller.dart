import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/models/purchase_demand_model.dart';

class PurchaseDemandController extends GetxController {

  var realtimeDB = RealtimeDB();
  var purchaseDemandId = "".obs;
  var isAdding = false.obs;
  var showLoader = false.obs;
  var allPurchaseDemands = <PurchaseDemandModel>[].obs;

  @override
  void onInit() {
    var id = _createPurchaseDemand();
    if(id != null){
      purchaseDemandId.value = id;
    }
    fetchAllPurchaseDemands();
    super.onInit();
  }

  String? _createPurchaseDemand(){
    return realtimeDB.createPurchaseDemand();
  }

  Future<void> fetchAllPurchaseDemands() async {
    showLoader.value = true;
    var demands = await realtimeDB.getAllPurchaseDemands();
    showLoader.value = false;
    allPurchaseDemands.value = demands;
    return;
  }


  //TODO: GET DATA FROM EXCEL FILE

  // Future<String?> pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform
  //       .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
  //   if (result != null) {
  //     return result.files.single.path;
  //   } else {
  //     return null;
  //   }
  // }

  // void pushModelsToFirebase(String filePath){
  //   var bytes = File(filePath).readAsBytesSync();
  //   var excel = Excel.decodeBytes(bytes);
  //
  //   for (var table in excel.tables.keys) {
  //     print(table); //sheet Name
  //
  //     var firstRow = excel.tables[table]!.row(0);
  //     for (var data in firstRow){
  //       if (data?.value == "Student Name"){
  //         for (int i = 1; i < excel[table].maxRows; i++){
  //           var s = excel[table].row(i).first;
  //           print("S ${s}");
  //         }
  //       }
  //     }
  //     // for (var row in excel.tables[table]!.rows) {
  //     //   print("ROW -> ${row[1]?.value}");
  //     // }
  //   }
  // }
}
