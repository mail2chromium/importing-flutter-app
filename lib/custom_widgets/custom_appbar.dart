import 'package:flutter/material.dart';

import '../custom_texts/MontserratText.dart';

// class CustomAppBar extends StatelessWidget {
//   // const CustomAppBar({Key? key}) : super(key: key);
//
//   final String title;
//
//   CustomAppBar(this.title);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: true,
//       iconTheme: const IconThemeData(color: Colors.black),
//       title:
//       MontserratText(title, 18, Colors.black, FontWeight.bold),
//       centerTitle: true,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//     );
//   }
// }

PreferredSizeWidget CustomAppBar(String title, {List<Widget> actions = const []}){
  return AppBar(
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Colors.black),
    title:
    MontserratText(title, 18, Colors.black, FontWeight.bold),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    actions: actions,
  );
}
