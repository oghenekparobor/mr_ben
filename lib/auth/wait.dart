import 'dart:async';

import 'package:Mr_Ben/models/category.dart';
import 'package:Mr_Ben/providers/categories.dart';
import 'package:Mr_Ben/screens/home_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitScreen extends StatefulWidget {
  static const route = '/waiitng';
  WaitScreen();
  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  List<Category> categories;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      categories = Provider.of<Categories>(context, listen: false).items;
      startTime(categories);
    });
  }

  startTime(dynamic cate) async {
    var duration = new Duration(milliseconds: 0);
    return new Timer(
      duration,
      () => Navigator.of(context).pushReplacementNamed(
        HomeOverview.route,
        arguments: cate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          Align(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              alignment: Alignment.center,
              child: FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo2.png',
                      width: 190,
                      height: 190,
                    ),
                    SizedBox(height: 5),
                    CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
