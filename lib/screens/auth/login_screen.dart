import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_capital/screens/menu_screen.dart';

import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../helpers/MyToast.dart';

class LoginScreen extends StatelessWidget {
  // const LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "email": null,
    "password": null
  };

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
        title: MontserratText("Login", 18, Colors.black, FontWeight.bold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: SafeArea(
        child: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (value){
                      _formData['email'] = value;
                    },
                  ),
                  SizedBox(
                    height: mediaQueryData.size.height * 0.035,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    onSaved: (value){
                      _formData['password'] = value;
                    },
                  ),
                  SizedBox(
                    height: mediaQueryData.size.height * 0.035,
                  ),
                  SizedBox(
                      width: mediaQueryData.size.width * 0.8,
                      height: 50,
                      child: MyDarkButton("Login", _btnLogin))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _btnLogin() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _formData["email"], password: _formData["password"]);

          if (userCredential.user != null){
            Get.to(() => MenuScreen());
          }

        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            MyToast("No user found for that email.");
          } else if (e.code == "wrong-password"){
            MyToast("Wrong password provided for that user.");
          }
        } catch (e) {
          MyToast("ERROR: $e");
        }
      } else {
        MyToast("Validation Error");
      }
    } else {
      MyToast("Unknown Error");
    }
  }
}
