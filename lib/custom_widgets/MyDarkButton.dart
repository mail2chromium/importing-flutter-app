import 'package:flutter/material.dart';
import 'package:my_capital/constants/MyColors.dart';

class MyDarkButton extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  final FontWeight fontWeight;
  final VoidCallback onClick;

  MyDarkButton(this.text, this.onClick,
      {this.color = accentColor,
      this.fontWeight = FontWeight.w600,
      this.textSize = 20});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: fontWeight,
            fontSize: textSize),
      ),
    );
  }
}
