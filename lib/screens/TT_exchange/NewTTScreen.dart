import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_capital/constants/MyColors.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';
import 'package:my_capital/custom_widgets/custom_loader.dart';
import 'package:my_capital/firebase/db/realtime_db.dart';
import 'package:my_capital/models/TT_model.dart';
import 'package:my_capital/models/agent_model.dart';
import 'package:my_capital/screens/TT_exchange/add_agent.dart';

import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../helpers/MyToast.dart';
import '../../models/currency_model.dart';
import 'add_currency_screen.dart';

class NewTTScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "agent_id": null,
    "currency_code": null,
    "rate": null,
    "amount": null,
    "currency_bought": null,
  };

  final _realtimeDB = RealtimeDB();

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
      appBar: CustomAppBar("Create TT"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: agentDropDown(),
                          ),
                          IconButton(
                            onPressed: _addAgent,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: currencyDropDown(),
                          ),
                          IconButton(
                            onPressed: _addCurrency,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Rate",
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Rate is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData["rate"] = value;
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Amount",
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Amount is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData["amount"] = value;
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Currency Bought",
                        ),
                        onSaved: (value) {
                          _formData["currency_bought"] = value;
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.8,
                  height: 50,
                  child: MyDarkButton("ADD", _btnCreateTT),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<DatabaseEvent> currencyDropDown() {
    return StreamBuilder(
        stream: _realtimeDB.listenForCurrency(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            DatabaseEvent obj = snapshot.data as DatabaseEvent;
            List<CurrencyModel> currencies = [];
            for (var currency in obj.snapshot.children) {
              var model = currencyResponseFromJson(json.encode(currency.value));
              currencies.add(model);
            }
            return DropdownButtonFormField(
              hint: MontserratText(
                  "Pick Currency", 18, Colors.black54, FontWeight.normal),
              items: currencies.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value.currencyCode,
                  child: Text("${value.currencyCode}"),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return "Currency is required";
                }
                return null;
              },
              onChanged: (String? value) {},
              onSaved: (value) {
                _formData["currency_code"] = value;
              },
            );
          } else {
            return const CustomLoader();
          }
        });
  }

  StreamBuilder<DatabaseEvent> agentDropDown() {
    return StreamBuilder(
        stream: _realtimeDB.listenForAgents(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            DatabaseEvent obj = snapshot.data as DatabaseEvent;
            List<AgentModel> agents = [];
            for (var currency in obj.snapshot.children) {
              var model = responseFromJson(json.encode(currency.value));
              model.id = currency.key;
              agents.add(model);
            }
            return DropdownButtonFormField(
              hint: MontserratText(
                  "Pick Agent", 18, Colors.black54, FontWeight.normal),
              items: agents.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value.id,
                  child: Text("${value.name}"),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return "Agent is required";
                }
                return null;
              },
              onChanged: (String? value) {},
              onSaved: (value) {
                _formData["agent_id"] = value;
              },
            );
          } else {
            return const CustomLoader();
          }
        });
  }

  void _addAgent() {
    Get.to(() => AddAgentScreen());
  }

  void _addCurrency() {
    Get.to(() => AddCurrencyScreen());
  }

  void _btnCreateTT() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        var ttModel = TTModel(
            agentId: _formData["agent_id"],
            currencyCode: _formData["currency_code"],
            rate: double.parse(_formData["rate"].toString()),
            amount: double.parse(_formData["amount"].toString()),
            currencyBought:
                double.parse(_formData["currency_bought"].toString()),
            createdAt: DateTime.now().toString());

        var amountAdded = await _realtimeDB.addAmountInCurrency(
            _formData["currency_code"],
            double.parse(_formData["amount"].toString()),
            double.parse(_formData["currency_bought"].toString()));

        if (amountAdded) {
          _realtimeDB.addTT(ttModel);
          Get.back();
        } else {
          MyToast("An Error occurred");
        }
      } else {
        MyToast("Validation Error");
      }
    } else {
      MyToast("Unknown Error");
    }
  }
}
