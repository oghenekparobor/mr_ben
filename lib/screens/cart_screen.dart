import 'package:Mr_Ben/auth/get_started.dart';
import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/providers/cart.dart';
import 'package:Mr_Ben/providers/orders.dart';
import 'package:Mr_Ben/screens/pay.dart';
import 'package:Mr_Ben/views/main_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const route = '/cart';
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context);
    Provider.of<Orders>(context, listen: false).deliveryCost();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shopping\ncart',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (ctx, constraint) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              child: ListView(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/swipe.png',
                                        width: 15,
                                        height: 15,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'swipe on an item to delete',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  for (int i = 0;
                                      i < cart.cartItems.length;
                                      i++)
                                    ci.CartItem(
                                      cartId:
                                          cart.cartItems.values.toList()[i].id,
                                      image: cart.cartItems.values
                                          .toList()[i]
                                          .imageUrl,
                                      mealid: cart.cartItems.keys.toList()[i],
                                      price: cart.cartItems.values
                                          .toList()[i]
                                          .price,
                                      quantity: cart.cartItems.values
                                          .toList()[i]
                                          .quantity,
                                      title: cart.cartItems.values
                                          .toList()[i]
                                          .title,
                                    )
                                ],
                              ),
                            ),
                          ),
                          MainButton(
                            label: 'Checkout',
                            color: Theme.of(context).accentColor,
                            padding: constraint.maxHeight * 0.025,
                            onpressed: cart.cartItems.isEmpty
                                ? null
                                : auth.isAuth
                                    ? () => Navigator.of(context)
                                        .pushNamed(Payment.route)
                                    : () => Navigator.of(context)
                                        .pushNamed(GetStarted.route),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
