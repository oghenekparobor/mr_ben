import 'package:Mr_Ben/providers/cart.dart';
import 'package:Mr_Ben/screens/delivery.dart';
import 'package:Mr_Ben/views/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { card, cash }

class Payment extends StatefulWidget {
  static const route = '/payment';
  const Payment({Key key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  PaymentMethod _paymentMethod = PaymentMethod.card;
  String _payment = 'card';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Text(
                'Payment',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Text(
                'Payment method',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .025),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black38,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Radio(
                          value: PaymentMethod.card,
                          groupValue: _paymentMethod,
                          onChanged: (PaymentMethod value) {
                            setState(() {
                              _paymentMethod = value;
                              _payment = 'card';
                            });
                          }),
                      title: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5)),
                            child: FaIcon(
                              FontAwesomeIcons.creditCard,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Card',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Radio(
                          value: PaymentMethod.cash,
                          groupValue: _paymentMethod,
                          onChanged: (PaymentMethod value) {
                            setState(() {
                              _paymentMethod = value;
                              _payment = 'cash';
                            });
                          }),
                      title: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.university,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Cash',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    'N${cart.cartTotalPrice}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              MainButton(
                label: 'Proceed to payment',
                padding: constraint.maxHeight * .025,
                color: Theme.of(context).accentColor,
                onpressed: () => Navigator.of(context).pushNamed(
                  Delivery.route,
                  arguments: _payment,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02)
            ],
          ),
        ),
      ),
    );
  }
}
