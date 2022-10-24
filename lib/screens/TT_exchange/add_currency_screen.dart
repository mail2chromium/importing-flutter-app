import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_capital/models/currency_model.dart';
import '../../constants/MyColors.dart';
import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../custom_widgets/custom_loader.dart';
import '../../firebase/db/realtime_db.dart';

//TODO: https://blog.devgenius.io/add-remove-textformfields-dynamically-in-flutter-5bef6948e778

class AddCurrencyScreen extends StatelessWidget {
  // const AddCurrencyScreen({Key? key}) : super(key: key);
  late BuildContext context;
  final _realtimeDB = RealtimeDB();

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
      appBar: CustomAppBar("Add Currency"),
      body: SafeArea(
        child: Container(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height,
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder(
                stream: _realtimeDB.listenForCurrency(),
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
                        itemCount: currencies.length,
                        itemBuilder: (BuildContext context, int index) {
                          var currency = currencies[index];
                          return ListTile(
                            title: MontserratText(
                                "${currency.name}", 18, Colors.black, FontWeight.normal),
                            trailing: MontserratText(
                                "${currency.symbol}", 18, Colors.black, FontWeight.bold),
                          );
                        });
                  } else {
                    return const CustomLoader();
                  }
                })),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _btnAddCurrency, child: const Icon(Icons.add)),
    );
  }

  void _btnAddCurrency() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      showSearchField: true,
      onSelect: (Currency currency) {
        final model = CurrencyModel(
            currencyCode: currency.code,
            name: currency.name,
            symbol: currency.symbol);
        _realtimeDB.addCurrency(model);
      },
    );
  }
}

// class AddCurrency extends StatefulWidget {
//   // const AddCurrency({Key? key}) : super(key: key);
//
//   @override
//   State<AddCurrency> createState() => _AddCurrencyState();
// }
//
// class _AddCurrencyState extends State<AddCurrency> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _nameController = TextEditingController();
//   static List<String?> friendsList = [null];
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQueryData = MediaQuery.of(context);
//     switch (mediaQueryData.orientation) {
//       case Orientation.portrait:
//         return _mainBody(mediaQueryData, Orientation.portrait, context);
//       case Orientation.landscape:
//         return _mainBody(mediaQueryData, Orientation.landscape, context);
//     }
//   }
//
//   Widget _mainBody(MediaQueryData mediaQueryData, Orientation orientation,
//       BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             MontserratText("Add Currency", 18, Colors.black, FontWeight.bold),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         actions: [
//           IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline))
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           width: mediaQueryData.size.width,
//           height: mediaQueryData.size.height,
//           padding: const EdgeInsets.all(10),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Form(
//                   child: Column(
//                     children: [
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       // TextField(
//                       //   enableInteractiveSelection: false,
//                       //   decoration: InputDecoration(
//                       //     hintText: "Pick Currency",
//                       //     hintStyle: TextStyle(
//                       //         fontSize: 16,
//                       //         fontWeight: FontWeight.normal,
//                       //         fontFamily: "Montserrat"),
//                       //     border: UnderlineInputBorder(
//                       //       borderSide: BorderSide(color: Colors.transparent),
//                       //     ),
//                       //     focusedBorder: UnderlineInputBorder(
//                       //       borderSide: BorderSide(color: Colors.transparent),
//                       //     ),
//                       //     enabledBorder: UnderlineInputBorder(
//                       //       borderSide: BorderSide(color: Colors.transparent),
//                       //     ),
//                       //     suffixIcon: GestureDetector(
//                       //       onTap: () {
//                       //         showCurrencyPicker(
//                       //           context: context,
//                       //           showFlag: true,
//                       //           showCurrencyName: true,
//                       //           showCurrencyCode: true,
//                       //           showSearchField: true,
//                       //           onSelect: (Currency currency) {
//                       //             print(
//                       //                 'Select currency: ${currency.name} ${currency.symbol}');
//                       //           },
//                       //         );
//                       //       },
//                       //       child: Icon(
//                       //         Icons.send,
//                       //         color: Colors.black,
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//                 MyDarkButton("Done", () {})
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// List<Widget> _getCurrencies() {
//   List<Widget> friendsTextFieldsList = [];
//   for (int i = 0; i < friendsList.length; i++) {
//     friendsTextFieldsList.add(Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         children: [
//           Expanded(child: CurrencyTextField(i)),
//           const SizedBox(
//             width: 16,
//           ),
//           // we need add button at last friends row only
//           _addRemoveButton(i == friendsList.length - 1, i),
//         ],
//       ),
//     ));
//   }
//   return friendsTextFieldsList;
// }
//
// Widget _addRemoveButton(bool add, int index) {
//   return InkWell(
//     onTap: () {
//       if (add) {
//         // add new text-fields at the top of all friends textfields
//         friendsList.insert(0, null);
//       } else
//         friendsList.removeAt(index);
//       setState(() {});
//     },
//     child: Container(
//       width: 30,
//       height: 30,
//       decoration: BoxDecoration(
//         color: (add) ? Colors.green : Colors.red,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Icon(
//         (add) ? Icons.add : Icons.remove,
//         color: Colors.white,
//       ),
//     ),
//   );
// }
// }

// class CurrencyTextField extends StatefulWidget {
//   // CurrencyTextField({Key? key}) : super(key: key);
//
//   final int index;
//
//   CurrencyTextField(this.index);
//
//   @override
//   State<CurrencyTextField> createState() => _CurrencyTextFieldState();
// }
//
// class _CurrencyTextFieldState extends State<CurrencyTextField> {
//   TextEditingController _nameController = TextEditingController();
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _nameController.text = _AddCurrencyState.friendsList[widget.index] ?? '';
//     });
//     return TextFormField(
//       controller: _nameController,
//       enabled: true,
//       readOnly: true,
//       onChanged: (v) => _AddCurrencyState.friendsList[widget.index] = v,
//       decoration: const InputDecoration(hintText: 'Pick Currency'),
//       onTap: (){
//         showCurrencyPicker(
//           context: context,
//           showFlag: true,
//           showCurrencyName: true,
//           showCurrencyCode: true,
//           showSearchField: true,
//           onSelect: (Currency currency) {
//             _AddCurrencyState.friendsList[widget.index] = "${currency.symbol} ${currency.name}";
//             print('Select currency: ${currency.name} ${currency.symbol}');
//           },
//         );
//       },
//       validator: (v) {
//         if (v!.trim().isEmpty) return 'Please enter something';
//         return null;
//       },
//     );
//   }
// }
