import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }
}
