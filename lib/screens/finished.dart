import 'dart:async';

import 'package:Mr_Ben/models/category.dart';
import 'package:Mr_Ben/providers/categories.dart';
import 'package:Mr_Ben/screens/home_overview.dart';
import 'package:Mr_Ben/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Finish extends StatefulWidget {
  static const route = '/finish';
  const Finish({Key key}) : super(key: key);

  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  List<Category> categories;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) async {
        await Provider.of<Categories>(context, listen: false).getCategories();
        categories = Provider.of<Categories>(context, listen: false).items;
      },
    );
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, () {
      Navigator.of(context)
          .pushReplacementNamed(HomeOverview.route, arguments: categories);
      showFinnalDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Image.asset('assets/images/done.gif'),
        ),
      ),
    );
  }
}

showFinnalDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text('Your orders has been placed successfully!'),
      ),
      actions: [
        RaisedButton(
          padding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: Text('Continue shopping'),
        ),
        FlatButton(
          onPressed: () async {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.route);
          },
          child: Text('View Orders'),
        ),
        SizedBox(width: 10)
      ],
    ),
  );
}
