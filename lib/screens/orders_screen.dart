import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/providers/orders.dart';
import 'package:Mr_Ben/screens/order_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  static const route = '/orders';
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context).userId;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              FutureBuilder(
                future: Provider.of<Orders>(context, listen: false)
                    .fetchOrdersOnline(int.parse(auth)),
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  } else {
                    if (dataSnapshot.data.toString().isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/no_data.png',
                            width: 70,
                            height: 120,
                          ),
                          Text('No transaction history'),
                        ],
                      );
                    } else {
                      return Consumer<Orders>(
                        builder: (ctx, orders, child) => orders.orders.length <
                                1
                            ? Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/order.png',
                                      // width: 150,
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'No orders yet',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Please add an item to cart \nthen complete checkout process',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: ListView(
                                  children: [
                                    for (int i = 0;
                                        i < orders.orders.length;
                                        i++)
                                      Container(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(
                                                OrderView.route,
                                                arguments: orders.orders[i],
                                              )
                                                  .then((value) {
                                                if (value != null)
                                                  showToast('Order cancelled');
                                              }),
                                              title: Text(
                                                orders.orders[i].orderID,
                                              ),
                                              subtitle: Text(
                                                  '${DateFormat.yMMMEd().format(DateTime.parse(orders.orders[i].dateTime))}'),
                                              trailing: FittedBox(
                                                child: Text(
                                                  'N${orders.orders[i].amount.toStringAsFixed(0)}',
                                                ),
                                              ),
                                            ),
                                            Divider(),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.CENTER,
    textColor: Colors.white,
    backgroundColor: Color.fromRGBO(0, 0, 0, 1),
    toastLength: Toast.LENGTH_LONG,
  );
}
