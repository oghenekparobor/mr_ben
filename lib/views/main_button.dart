import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    this.padding,
    this.color,
    this.onpressed,
    this.label,
  });

  final double padding;
  final Color color;
  final Function onpressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: color,
      padding: EdgeInsets.symmetric(
        vertical: padding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onPressed: onpressed,
      child: Text(
        '$label',
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}
