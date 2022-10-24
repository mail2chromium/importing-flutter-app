import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:my_capital/constants/FirebaseConstants.dart';
import 'package:my_capital/models/TT_model.dart';
import 'package:my_capital/models/agent_model.dart';
import 'package:my_capital/models/cash_model.dart';
import 'package:my_capital/models/currency_model.dart';
import 'package:my_capital/models/invoice_model.dart';
import 'package:my_capital/models/purchase_demand_model.dart';
import 'package:my_capital/models/supplier_model.dart';

class RealtimeDB {
  final _ref = FirebaseDatabase.instance.ref();
  DatabaseReference? _supplierDBRef;
  DatabaseReference? _cashDepositDBRef;
  DatabaseReference? _agentDBRef;
  DatabaseReference? _currencyDBRef;
  DatabaseReference? _ttDBRef;
  DatabaseReference? _totalCashDBRef;
  DatabaseReference? _purchaseDemandDBRef;

  // StreamSubscription<DatabaseEvent>? _testSubscription;

  RealtimeDB() {
    _supplierDBRef = _ref.child(SUPPLIER);
    _cashDepositDBRef = _ref.child(CASH);
    _agentDBRef = _ref.child(AGENT);
    _currencyDBRef = _ref.child(CURRENCY);
    _ttDBRef = _ref.child(TT);
    _totalCashDBRef = _ref.child(TOTAL_CASH);
    _purchaseDemandDBRef = _ref.child(PURCHASE_DEMAND);
  }

  //TODO:  Purchase Demand
  String? createPurchaseDemand() {
    var ref = _purchaseDemandDBRef?.push();
    return ref?.key;
  }

  Future<void>? addPurchaseDemand(
      String purchaseDemandKey, PurchaseDemandModel model) async {
    var event = await _purchaseDemandDBRef!
        .child(purchaseDemandKey)
        .child(TOTAL_QUANTITY)
        .once();
    var snapshot = event.snapshot;
    if (snapshot.value != null) {
      var previouseValue = snapshot.value! as int;
      var total = previouseValue + model.quantityDemanded!;
      await _purchaseDemandDBRef
          ?.child(purchaseDemandKey)
          .child(TOTAL_QUANTITY)
          .set(total);
    } else {
      await _purchaseDemandDBRef
          ?.child(purchaseDemandKey)
          .child(TOTAL_QUANTITY)
          .set(model.quantityDemanded);
      await _purchaseDemandDBRef
          ?.child(purchaseDemandKey)
          .child(CREATED_AT)
          .set(DateTime.now().toString());
    }
    return _purchaseDemandDBRef
        ?.child(purchaseDemandKey)
        .child(DEMANDS)
        .push()
        .set(model.toJson());
  }

  Stream<DatabaseEvent>? listenForPurchaseDemand(String purchaseDemandKey) {
    return _purchaseDemandDBRef
        ?.child(purchaseDemandKey)
        .child(DEMANDS)
        .onValue;
  }

  Future<List<PurchaseDemandModel>> getAllPurchaseDemands() async {
    final snapshot = await _purchaseDemandDBRef?.get();

    List<PurchaseDemandModel> allDemands = [];

    if (snapshot?.value != null) {
      final map = snapshot?.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        var model = PurchaseDemandModel(
            id: key,
            createdAt: value["created_at"],
            quantityDemanded: value["total_quantity"]);

        allDemands.add(model);
      });
    }

    return allDemands;
  }

  Future<void> createInvoice(InvoiceModel invoice) async {
    await _purchaseDemandDBRef!
        .child(invoice.demandDraftId!)
        .child(INVOICE)
        .set(invoice.toJson());

    for (var item in invoice.items!){
      await _purchaseDemandDBRef!.child(invoice.demandDraftId!).child(INVOICE).child("models").push().set(item.toJson());
    }
  }

  //TODO: TT
  void addTT(TTModel model) {
    _ttDBRef?.push().set(model.toJson());
  }

  Future<List<TTModel>> getAllTTs() async {
    final snapshot = await _ttDBRef?.get();
    List<TTModel> allTTs = [];

    if (snapshot?.value != null) {
      final map = snapshot?.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        TTModel model = TTModel(
            id: key,
            agentId: value["agentId"],
            currencyCode: value["currencyCode"],
            rate: double.parse(value["rate"].toString()),
            currencyBought: double.parse(value["currencyBought"].toString()),
            createdAt: value["createdAt"],
            amount: double.parse(value["amount"].toString()));

        allTTs.add(model);
      });
    }

    return allTTs;
  }

  //TODO: CURRENCY
  void addCurrency(CurrencyModel model) {
    _currencyDBRef?.child(model.currencyCode!).set(model.toJson());
  }

  Future<bool> addAmountInCurrency(
      String currencyCode, double addAmount, double addCurrencyBought) async {
    var event = await _currencyDBRef!.child(currencyCode).once();
    var snapshot = event.snapshot;
    if (snapshot.value != null) {
      var result = currencyResponseFromJson(json.encode(snapshot.value));
      // print("GOT RESULT: ${result.amount} | ${result.currencyBought}");

      var currentAmount = result.amount!;
      var newAmount = currentAmount + addAmount;
      await _currencyDBRef?.child(currencyCode).child(AMOUNT).set(newAmount);

      var currencyBought = result.currencyBought!;
      var newCurrencyBoughtAmount = currencyBought + addCurrencyBought;
      await _currencyDBRef
          ?.child(currencyCode)
          .child(CURRENCY_BOUGHT)
          .set(newCurrencyBoughtAmount);
      return true;
    } else {
      return false;
    }
  }

  Stream<DatabaseEvent>? listenForCurrency() {
    return _currencyDBRef?.onValue;
  }

  //TODO: AGENT
  void addAgent(AgentModel model) {
    _agentDBRef?.child(model.name!.toLowerCase()).set(model.toJson());
  }

  Stream<DatabaseEvent>? listenForAgents() {
    return _agentDBRef?.onValue;
  }

  //TODO: CASH
  Stream<DatabaseEvent>? listenForTotalCash() {
    return _totalCashDBRef?.onValue;
  }

  void addCash(CashModel model) async {
    var snapshot = await _totalCashDBRef?.get();
    if (snapshot?.value != null) {
      var totalAmount = double.parse(snapshot!.value.toString());
      totalAmount += model.amount!;
      _totalCashDBRef?.set(totalAmount);
      _cashDepositDBRef?.push().set(model.toJson());
    } else {
      _totalCashDBRef?.set(model.amount!);
      _cashDepositDBRef?.push().set(model.toJson());
    }
  }

  // void addCash(CashModel model) async {
  //   var snapshot = await _cashDepositDBRef?.child(TOTAL_CASH).get();
  //   if (snapshot?.value != null) {
  //     var totalAmount = double.parse(snapshot!.value.toString());
  //     totalAmount += model.amount!;
  //     _cashDepositDBRef?.child(TOTAL_CASH).set(totalAmount);
  //     _cashDepositDBRef?.push().set(model.toJson());
  //   } else {
  //     _cashDepositDBRef?.child(TOTAL_CASH).set(model.amount!);
  //     _cashDepositDBRef?.push().set(model.toJson());
  //   }
  // }

  Future<List<CashModel>> getAllCash() async {
    final snapshot = await _cashDepositDBRef?.get();
    List<CashModel> allCash = [];

    if (snapshot?.value != null) {
      final map = snapshot?.value as Map<dynamic, dynamic>;

      try {
        map.forEach((key, value) {
          CashModel model = CashModel(
              id: key,
              amount: double.parse(value["amount"].toString()),
              datetime: value["datetime"]);

          allCash.add(model);
        });
      } catch (e) {
        print("ERROR :$e");
      }
    }

    return allCash;
  }

  //TODO: Suppliers
  void addSupplier(SupplierModel supplierModel) {
    _supplierDBRef
        ?.child(supplierModel.name!.toLowerCase())
        .set(supplierModel.toJson());
  }

  void addSupplierCurrency(String supplierId, String currencyCode) {
    var supplierCurrency =
        SupplierCurrency(currencyCode: currencyCode, credit: 0.0);
    _supplierDBRef
        ?.child(supplierId)
        .child(CURRENCY)
        .child(currencyCode)
        .set(supplierCurrency.toJson());
  }

  Future<List<SupplierModel>> getAllSuppliers() async {
    final snapshot = await _supplierDBRef?.get();
    List<SupplierModel> allSuppliers = [];

    if (snapshot != null && snapshot.value != null) {
      final map = snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        SupplierModel model = SupplierModel(
            id: key,
            name: value["name"],
            country: value["country"],
            contact: value["contact"]);
        model.currencies = <SupplierCurrency>[];

        var currencyValue = value["currency"];
        if (currencyValue != null) {
          var currencyMap = currencyValue as Map<dynamic, dynamic>;

          currencyMap.forEach((key, value) {
            model.currencies?.add(SupplierCurrency(
                currencyCode: value["currencyCode"],
                credit: double.parse(value["credit"].toString())));
          });
        }

        allSuppliers.add(model);
      });
    }

    return allSuppliers;
  }
}
