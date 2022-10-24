import 'package:flutter/material.dart';

import '../../custom_widgets/MyDarkButton.dart';
import '../../custom_widgets/custom_appbar.dart';

class SelectInventoryScreen extends StatelessWidget {
  // const SelectInventoryScreen({Key? key}) : super(key: key);
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
      appBar: CustomAppBar("Select Inventory"),
      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Inventory Type",
                      contentPadding: EdgeInsets.only(top: -8.0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Whatsapp number is required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _formData['agent_whatsapp'] = value?.trim();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Name",
                      contentPadding: EdgeInsets.only(top: -8.0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Whatsapp number is required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _formData['agent_whatsapp'] = value?.trim();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Suffix",
                      contentPadding: EdgeInsets.only(top: -8.0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Whatsapp number is required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _formData['agent_whatsapp'] = value?.trim();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Notes",
                      contentPadding: EdgeInsets.only(top: -8.0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Whatsapp number is required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _formData['agent_whatsapp'] = value?.trim();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: mediaQueryData.size.width * 0.8,
                    height: 50,
                    child: MyDarkButton("Save", _btnCreate))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _btnCreate(){

  }
}
