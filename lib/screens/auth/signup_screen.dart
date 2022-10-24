import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_capital/screens/auth/login_screen.dart';

import '../../constants/MyColors.dart';
import '../../custom_texts/MontserratText.dart';
import '../../custom_widgets/MyDarkButton.dart';
import '../../helpers/MyToast.dart';

class SignUpScreen extends StatelessWidget {
  // const SignUpScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "name": null,
    "email": null,
    "password": null,
    "confirm_password": null,
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
        title: MontserratText("Sign UP", 18, Colors.black, FontWeight.bold),
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
                      labelText: "Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      } else if (value.length > 40) {
                        return "Name is too long";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['name'] = value;
                    },
                  ),
                  SizedBox(
                    height: mediaQueryData.size.height * 0.035,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!value.isEmail) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 8) {
                        return "Password length required is 8";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['password'] = value;
                    },
                    onChanged: (value) {
                      _formData['password'] = value;
                    },
                  ),
                  SizedBox(
                    height: mediaQueryData.size.height * 0.035,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm Password is required";
                      } else if (value.length < 8) {
                        return "Confirm Password length required is 8";
                      } else if (_formData['password'] != value) {
                        print("GOT VALUE: ${_formData['password']} | $value");
                        return "Confirm Password does not match";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['confirm_password'] = value;
                    },
                  ),
                  SizedBox(
                    height: mediaQueryData.size.height * 0.035,
                  ),
                  SizedBox(
                      width: mediaQueryData.size.width * 0.8,
                      height: 50,
                      child: MyDarkButton("Create Account", _btnSignUp)),
                  InkWell(
                      onTap: _btnGoToLogin,
                      child: MontserratText(
                        "Already a user? Go to Login",
                        16,
                        Colors.blue,
                        FontWeight.normal,
                        top: 20,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _btnGoToLogin() {
    Get.to(() => LoginScreen());
  }

  void _btnSignUp() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _formData["email"], password: _formData["password"]);

          userCredential.user?.updateDisplayName(_formData["name"]);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            MyToast('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            MyToast('The account already exists for that email.');
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
