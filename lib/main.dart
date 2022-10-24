import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_capital/constants/MyColors.dart';
import 'package:my_capital/routes.dart';
import 'package:my_capital/screens/TT_exchange/NewTTScreen.dart';
import 'package:my_capital/screens/TT_exchange/TTExchangeScreen.dart';
import 'package:my_capital/screens/auth/login_screen.dart';
import 'package:my_capital/screens/auth/signup_screen.dart';
import 'package:my_capital/screens/cash/cash_deposit_screen.dart';
import 'package:my_capital/screens/cash/cash_history_screen.dart';
import 'package:my_capital/screens/menu_screen.dart';
import 'package:my_capital/screens/purchase_demand/purchase_demand_screen.dart';
import 'package:my_capital/screens/supplier/AddSupplier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_capital/screens/supplier/all_supplier_screen.dart';
import 'firebase_options.dart';

// void main() {
//   runApp(MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  static Map<int, Color> color = {
    50: Color.fromRGBO(6, 125, 231, .1),
    100: Color.fromRGBO(6, 125, 231, .2),
    200: Color.fromRGBO(6, 125, 231, .3),
    300: Color.fromRGBO(6, 125, 231, .4),
    400: Color.fromRGBO(6, 125, 231, .5),
    500: Color.fromRGBO(6, 125, 231, .6),
    600: Color.fromRGBO(6, 125, 231, .7),
    700: Color.fromRGBO(6, 125, 231, .8),
    800: Color.fromRGBO(6, 125, 231, .9),
    900: Color.fromRGBO(6, 125, 231, 1),
  };

  MaterialColor colorCustom = MaterialColor(0x067DE7FF, color);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KHATA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: routes,
      initialRoute: "/",
      // home: MenuScreen(),
      // home:  AddSupplierScreen(),
      // home:  AddCurrency(),
      // home:  CashDepositScreen(),
      // home: TTExchangeScreen(),
      // home:  NewTTScreen(),
      // home: PurchaseDemandScreen()
      // home: SignUpScreen(),
      // home: LoginScreen(),
      // home: CashHistoryScreen(),
      // home: AllSuppliersScreen(),
    );
  }
}

// https://app.diagrams.net/#G1yQARYHIR9hpiw8Lk_5d7jvXPuz5R4YwI
