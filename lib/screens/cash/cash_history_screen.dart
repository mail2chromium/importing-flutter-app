import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:my_capital/controllers/cash_history_controller.dart';
import 'package:my_capital/custom_extensions/CurrenyExtension.dart';
import 'package:my_capital/custom_extensions/date_extension.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';
import 'package:my_capital/custom_widgets/custom_loader.dart';

import '../../constants/MyColors.dart';
import '../../custom_texts/MontserratText.dart';
import '../../firebase/db/realtime_db.dart';

class CashHistoryScreen extends StatelessWidget {
  // const CashHistoryScreen({Key? key}) : super(key: key);
  final db = RealtimeDB();
  final _cashController = Get.put(CashHistoryController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    switch (mediaQueryData.orientation) {
      case Orientation.portrait:
        return _mainBody(mediaQueryData, Orientation.portrait);
      case Orientation.landscape:
        return _mainBody(mediaQueryData, Orientation.landscape);
    }
  }

  Widget _mainBody(MediaQueryData mediaQueryData, Orientation orientation) {
    return Scaffold(
      appBar: CustomAppBar("Cash History"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              StreamBuilder(
                  stream: db.listenForTotalCash(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      DatabaseEvent obj = snapshot.data as DatabaseEvent;
                      if (obj.snapshot.value != null) {
                        var rupee = double.parse(obj.snapshot.value.toString());
                        return MontserratText("Balance: ${rupee.toRupee()}", 30,
                            Colors.black, FontWeight.bold,
                            textAlign: TextAlign.center, underline: true);
                      } else {
                        return MontserratText(
                            "...", 30, Colors.black, FontWeight.bold);
                      }
                    } else {
                      return MontserratText("...", 30, Colors.black, FontWeight.bold);
                    }
                  }),
              Container(
                width: mediaQueryData.size.width * 0.9,
                height: 2,
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                color: accentColor,
              ),
              Obx(
                () => _cashController.showLoader.value
                    ? const CustomLoader()
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _cashController.allCash.length,
                            itemBuilder: (BuildContext context, int index) {
                              var cash =
                              _cashController.allCash[index];
                              return Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      // An action can be bigger than the others.
                                      backgroundColor: Color(0xFF0A30D5),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                      onPressed: (BuildContext context) {},
                                    ),
                                    SlidableAction(
                                      backgroundColor: Color(0xFFE30606),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      onPressed: (BuildContext context) {},
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: MontserratText("Rs.${cash.amount}", 18,
                                      Colors.black, FontWeight.bold),
                                  trailing: MontserratText(DateTime.parse(cash.datetime!).makeFormat(), 14,
                                      Colors.black45, FontWeight.normal),
                                ),
                              );
                            }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
