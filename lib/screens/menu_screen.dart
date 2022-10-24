import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_capital/constants/MyColors.dart';
import 'package:my_capital/custom_extensions/CurrenyExtension.dart';
import 'package:my_capital/custom_texts/MontserratText.dart';
import 'package:my_capital/custom_widgets/custom_loader.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/screens/cash/cash_deposit_screen.dart';
import 'package:my_capital/screens/cash/cash_history_screen.dart';
import 'package:my_capital/screens/purchase_demand/purchase_demand_screen.dart';
import 'package:my_capital/screens/shipments/main_shipments_screen.dart';
import 'package:my_capital/screens/supplier/all_supplier_screen.dart';

import '../custom_widgets/MyDarkButton.dart';
import '../models/currency_model.dart';
import 'TT_exchange/TTExchangeScreen.dart';

class MenuScreen extends StatelessWidget {
  // const MenuScreen({Key? key}) : super(key: key);
  final db = RealtimeDB();

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: StreamBuilder(
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
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _btnCashDeposit,
            icon: const Icon(
              Icons.add_circle_outline,
              color: primaryColor,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: mediaQueryData.size.height * 0.15,
                  child: StreamBuilder(
                      stream: db.listenForCurrency(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          DatabaseEvent obj = snapshot.data as DatabaseEvent;
                          List<CurrencyModel> currencies = [];
                          for (var currency in obj.snapshot.children) {
                            var model = currencyResponseFromJson(
                                json.encode(currency.value));
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
                                  child: _currencies(
                                      "${currency.currencyCode}",
                                      currency.currencyBought!,
                                      currency.amount!));
                            },
                          );
                        } else {
                          return CustomLoader();
                        }
                      }),
                ),
                Container(
                  height: 50,
                  width: mediaQueryData.size.width,
                  margin: const EdgeInsets.only(top: 30, bottom: 20),
                  child: MyDarkButton("Cash History", _btnCashHistory),
                ),
                Container(
                  height: 50,
                  width: mediaQueryData.size.width,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: MyDarkButton("TT Exchange", _btnTTExchange),
                ),
                Container(
                  height: 50,
                  width: mediaQueryData.size.width,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: MyDarkButton("Purchase Demand", _btnPurchaseDemand),
                ),
                Container(
                  height: 50,
                  width: mediaQueryData.size.width,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: MyDarkButton("Supplier", _btnSupplier),
                ),
                Container(
                  height: 50,
                  width: mediaQueryData.size.width,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: MyDarkButton("Inventory", _btnInventory),
                ),
                Container(
                  height: 50,
                  width: mediaQueryData.size.width,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: MyDarkButton("Shipment", _btnShipment),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _currencies(String name, double amount, double pkrAmount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MontserratText("$name: ${amount.toForeignCurrency(name)}", 18,
            Colors.black, FontWeight.bold),
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

  void _btnCashDeposit() {
    Get.to(() => CashDepositScreen());
  }

  void _btnCashHistory() {
    Get.to(() => CashHistoryScreen());
  }

  void _btnTTExchange() {
    Get.to(() => TTExchangeScreen());
  }

  void _btnPurchaseDemand() {
    // Get.to(() => PurchaseDemandScreen());
    Get.toNamed("/purchase_demand");
  }

  void _btnSupplier() {
    Get.to(() => AllSuppliersScreen());
  }

  void _btnInventory(){
    Get.toNamed("/inventory_main");
  }

  void _btnShipment() {
    // Get.to(() => MainShipmentScreen());
    Get.toNamed("/all_shipments");
  }
}
