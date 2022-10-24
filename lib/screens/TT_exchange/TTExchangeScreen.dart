import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_capital/controllers/tt_controller.dart';
import 'package:my_capital/custom_extensions/CurrenyExtension.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';
import 'package:my_capital/screens/TT_exchange/NewTTScreen.dart';

import '../../constants/MyColors.dart';
import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/custom_loader.dart';
import '../../firebase/db/realtime_db.dart';
import '../../models/currency_model.dart';

class TTExchangeScreen extends StatelessWidget {
  // const TTExchangeScreen({Key? key}) : super(key: key);

  final db = RealtimeDB();
  final _ttController = Get.put(TTController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    switch (mediaQueryData.orientation) {
      case Orientation.portrait:
        return _mainBody(mediaQueryData, Orientation.portrait, context);
      case Orientation.landscape:
        return _mainBody(mediaQueryData, Orientation.landscape, context);
    }
  }

  Widget _mainBody(MediaQueryData mediaQueryData, Orientation orientation,
      BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("TT Exchange"),
      floatingActionButton: FloatingActionButton(
        onPressed: _btnAddTT,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                StreamBuilder(
                    stream: db.listenForTotalCash(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        DatabaseEvent obj = snapshot.data as DatabaseEvent;
                        var rupee = double.parse(obj.snapshot.value.toString());
                        return MontserratText(
                          "Balance: ${rupee.toRupee()}",
                          18,
                          Colors.black,
                          FontWeight.bold,
                          textAlign: TextAlign.center,
                          underline: false,
                          top: 20,
                        );
                      } else {
                        return MontserratText(
                            "...", 30, Colors.black, FontWeight.bold);
                      }
                    }),
                SizedBox(
                  height: orientation == Orientation.portrait
                      ? mediaQueryData.size.height * 0.15
                      : mediaQueryData.size.height * 0.3,
                  child: StreamBuilder(
                      stream: db.listenForCurrency(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          DatabaseEvent obj = snapshot.data as DatabaseEvent;
                          List<CurrencyModel> currencies = [];
                          for (var currency in obj.snapshot.children) {
                            var model = currencyResponseFromJson(json.encode(currency.value));
                            currencies.add(model);
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: currencies.length,
                            itemBuilder: (BuildContext context, int index) {
                              var currency = currencies[index];
                              return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: accentColor, width: 3),
                                  ),
                                  child: _currencies("${currency.currencyCode}", currency.currencyBought!, currency.amount!));
                            },
                          );
                        } else {
                          return CustomLoader();
                        }
                      }),
                ),
                Obx(
                  () => _ttController.showLoader.value
                      ? const CustomLoader()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _ttController.allTTs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var tt =
                            _ttController.allTTs[index];
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
                                leading: MontserratText(_getCurrency(tt.currencyCode!), 24,
                                    Colors.green, FontWeight.bold),
                                title: MontserratText("${tt.agentId}", 18,
                                    Colors.black, FontWeight.bold),
                                subtitle: MontserratText("${tt.createdAt}", 14,
                                    Colors.black45, FontWeight.normal),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    MontserratText("${_getCurrency(tt.currencyCode!)} ${tt.currencyBought}", 18, Colors.black,
                                        FontWeight.bold),
                                    MontserratText("Rs: ${tt.amount}", 14,
                                        Colors.black45, FontWeight.normal)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrency(String currencyCode) {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: currencyCode);
    return format.currencySymbol;
  }

  Widget _currencies(String name, double amount, double pkrAmount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MontserratText(
            "$name: ${amount.toForeignCurrency(name)}", 18, Colors.black, FontWeight.bold),
        Container(
          width: 50,
          height: 2,
          color: Colors.black,
          margin: const EdgeInsets.symmetric(vertical: 5),
        ),
        MontserratText(pkrAmount.toRupee(), 14, Colors.black, FontWeight.normal)
      ],
    );
  }

  void _btnAddTT() {
    Get.to(() => NewTTScreen());
  }
}
