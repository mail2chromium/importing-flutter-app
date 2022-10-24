import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_capital/custom_widgets/custom_appbar.dart';
import 'package:my_capital/models/agent_model.dart';

import '../../custom_widgets/MyDarkButton.dart';
import '../../firebase/db/realtime_db.dart';
import '../../helpers/MyToast.dart';

class AddAgentScreen extends StatelessWidget {

  // const AddAgentScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "agent_name": null,
    "agent_contact": null,
    "agent_whatsapp": null,
  };

  final _currencyController = TextEditingController();
  final _realtimeDB = RealtimeDB();

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

  Widget _mainBody(MediaQueryData mediaQueryData, Orientation orientation){
    return Scaffold(
      appBar: CustomAppBar("Add Agent"),
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
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Name",
                            contentPadding: EdgeInsets.only(top: -8.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Agent name is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['agent_name'] = value?.trim();
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        controller: _currencyController,
                        decoration: const InputDecoration(
                            labelText: "Contact Number",
                            contentPadding: EdgeInsets.only(top: -8.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Contact number is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['agent_contact'] = value?.trim();
                        },
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.035,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Wechat / Whatsapp",
                            contentPadding: EdgeInsets.only(top: -8.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Whatsapp number is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['agent_whatsapp'] = value?.trim();
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
                    child: MyDarkButton("Add Agent", _btnAddAgent))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _btnAddAgent(){
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        AgentModel agentModel = AgentModel(
          name: _formData["agent_name"],
          contact: _formData["agent_contact"],
          whatsapp: _formData["agent_whatsapp"]
        );

        _realtimeDB.addAgent(agentModel);
        Get.back();
      } else {
        MyToast("Validation Error");
      }
    } else {
      MyToast("Unknown Error");
    }
  }
}
