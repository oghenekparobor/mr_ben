import 'dart:async';
import 'dart:ui';

import 'package:Mr_Ben/auth/wait.dart';
import 'package:Mr_Ben/models/category.dart';
import 'package:Mr_Ben/providers/categories.dart';
import 'package:Mr_Ben/screens/home_overview.dart';
import 'package:Mr_Ben/views/main_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Category> categories;

  startTime(dynamic cate) async {
    var duration = new Duration(milliseconds: 1);
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
      body: FutureBuilder(
        future: Provider.of<Categories>(context, listen: false).getCategories(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Container(color: Colors.white),
                Align(
                  child: Container(
                    width: 250,
                    height: 250,
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
                            width: 180,
                            height: 180,
                          ),
                          SizedBox(height: 15),
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
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return TryAgain();
          } else {
            if (snapshot.hasError) {
              return TryAgain();
            } else {
              return Consumer<Categories>(
                builder: (ctx, categories, child) => WaitScreen(),
              );
            }
          }
        },
      ),
    );
  }
}

class TryAgain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/wifi.png',
            width: 100,
            height: 100,
          ),
          Text(
            'No internet connection',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your internet connection is currently \nnot available please check or try again',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
          SizedBox(height: 25),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: MainButton(
              label: 'Try again',
              color: Theme.of(context).primaryColor,
              padding: 15,
              onpressed: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
          ),
        ],
      ),
    );
  }
}
