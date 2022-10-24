import 'package:flutter/material.dart';

import 'custom_progress_dialog.dart';

class MyLoadingDialog {
  MyLoadingDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: const bool.fromEnvironment("dismiss dialog"),
        builder: (BuildContext context) {
          return CustomProgressDialog("$text");
        });
  }
}