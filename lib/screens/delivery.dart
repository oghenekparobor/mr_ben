import 'dart:convert';
import 'dart:math';

import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/providers/cart.dart';
import 'package:Mr_Ben/providers/orders.dart';
import 'package:Mr_Ben/screens/finished.dart';
import 'package:Mr_Ben/screens/profile_edit.dart';
import 'package:Mr_Ben/views/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

enum DeliveryMethod { home, pickup }

void showCustomDialog({
  String address,
  double cost,
  String delivery,
  String payment,
  Cart cart,
  Auth auth,
  BuildContext context,
  String email,
  double deliveryCost,
}) {
  showDialog(
    context: context,
    builder: (context) => Center(
      child: Container(
        width: double.infinity,
        height: 320,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Material(
                  color: Colors.black38,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    child: FittedBox(
                      child: Text(
                        'Please note',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'DELIVERY TO:',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '$address',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Cost:',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'N${deliveryCost.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'TOTAL:',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'N${(cart.cartTotalPrice + deliveryCost).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Text(
                          'Delivery is added to your order',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: FittedBox(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      color: Theme.of(context).accentColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        if (payment == 'cash') {
                          finaliseOrders(
                            cart,
                            auth,
                            delivery,
                            address,
                            payment,
                            deliveryCost,
                            context,
                          );
                        } else {
                          cardPayment(
                              (cost + deliveryCost),
                              delivery,
                              payment,
                              email,
                              auth,
                              cart,
                              address,
                              deliveryCost,
                              context);
                        }
                      },
                      child: FittedBox(
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

finaliseOrders(Cart cart, Auth auth, String delivery, String address,
    String payment, double deliveryCo, BuildContext context) async {
  await Provider.of<Orders>(context, listen: false).addOrder(
    cartProducts: cart.cartItems.values.toList(),
    total: (cart.cartTotalPrice + deliveryCo),
    address: address,
    delivery: delivery,
    payment: payment,
    userid: int.parse(auth.userId),
  );
  print('delivery cost: $deliveryCo');
  cart.clearCart();
  Navigator.of(context).pushNamedAndRemoveUntil(Finish.route, (route) => false);
  showToast('Your order has been placed successful');
}

void cardPayment(
    double cost,
    String delivery,
    String payment,
    String email,
    Auth auth,
    Cart cart,
    String address,
    double deliveryCost,
    BuildContext context) async {
  Charge charge = Charge()
    ..amount = cost.toInt() * 100
    ..reference = 'BOF_${DateTime.now()}'
    // ..subAccount = _subAccount
    ..email = email;
  CheckoutResponse response = await PaystackPlugin.checkout(
    context,
    charge: charge,
    logo: Image.asset('assets/images/logo-2.png', width: 90),
    method: CheckoutMethod.card,
  );
  if (response.verify)
    finaliseOrders(
        cart, auth, delivery, address, payment, deliveryCost, context);
}

class Delivery extends StatefulWidget {
  static const route = '/delivery';
  const Delivery({Key key}) : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  DeliveryMethod _deliveryMethod = DeliveryMethod.home;
  String _delivery = 'door_delivery';
  Map<String, dynamic> details;
  double cost;

  var _publicKey = 'pk_live_2f6a28cf8e27012e5353c6bb9186d7f20a6f01ea';
  // var _subAccount = 'ACCT_fcbkutqabzvjrkw';
  var geolocator = Geolocator();

  void _validation({
    String name,
    String address,
    String phone,
    double cost,
    String delivery,
    String payment,
    Cart cart,
    Auth auth,
  }) {
    if (name.isEmpty || address.isEmpty || phone.isEmpty) {
      Navigator.of(context).pushNamed(ProfileEdit.route);
      showToast('Please complete your profile before checkout');
    } else {
      makePayment(
        cost: cost,
        delivery: delivery,
        payment: payment,
        email: auth.email,
        auth: auth,
        cart: cart,
        address: address,
      );
    }
  }

  void makePayment({
    double cost,
    String delivery,
    String payment,
    String email,
    Auth auth,
    Cart cart,
    String address,
    double deliveryCost = 0.00,
  }) async {
    if (payment == 'cash' && delivery == 'pickup')
      finaliseOrders(cart, auth, delivery, address, payment, 0.00, context);
    if (payment == 'card' && delivery == 'pickup')
      cardPayment(cost, delivery, payment, email, auth, cart, address,
          deliveryCost, context);
    if (payment == 'card' && delivery == 'door_delivery')
      calculationDeliveryCost(address).then(
        (value) => showCustomDialog(
          address: address,
          auth: auth,
          cart: cart,
          context: context,
          cost: cost,
          delivery: delivery,
          email: email,
          payment: payment,
          deliveryCost: value,
        ),
      );
    if (payment == 'cash' && delivery == 'door_delivery')
      calculationDeliveryCost(address).then(
        (value) => showCustomDialog(
          address: address,
          auth: auth,
          cart: cart,
          context: context,
          cost: cost,
          delivery: delivery,
          email: email,
          payment: payment,
          deliveryCost: value,
        ),
      );
  }

  Future<double> calculationDeliveryCost(address) async {
    var query = await Geocoder.local.findAddressesFromQuery(address);
    var first = query.first.coordinates;
    return calculateDistance(
          first.latitude,
          first.longitude,
          5.5424501614534964,
          5.766253739530611,
        ) *
        250;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: _publicKey);

    Future.delayed(Duration.zero).then((value) async {
      cost = Provider.of<Orders>(context, listen: false).cost;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false);
    if (auth.userDetail != null) details = json.decode(auth.userDetail);
    final cart = Provider.of<Cart>(context, listen: false);
    var payment = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
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
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        // color: Color.fromRGBO(246, 246, 249, 1),
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Container(
            height: constraint.maxHeight,
            child: ListView(
              children: [
                SizedBox(height: 10),
                Text(
                  'Delivery',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: constraint.maxHeight * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(ProfileEdit.route),
                      child: Text(
                        'Change',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: constraint.maxHeight * .01),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${details['username']}',
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      SizedBox(height: 5),
                      Text(
                        '${details['address']}',
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Divider(),
                      SizedBox(height: 5),
                      Text(
                        '${details['mobile']}',
                        maxLines: 1,
                        softWrap: true,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
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
                SizedBox(height: constraint.maxHeight * .01),
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
                            value: DeliveryMethod.home,
                            groupValue: _deliveryMethod,
                            onChanged: (DeliveryMethod value) {
                              setState(() {
                                _deliveryMethod = value;
                                _delivery = 'door_delivery';
                              });
                            }),
                        title: Row(
                          children: [
                            Text(
                              'Door delivery',
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
                            value: DeliveryMethod.pickup,
                            groupValue: _deliveryMethod,
                            onChanged: (DeliveryMethod value) {
                              setState(() {
                                _deliveryMethod = value;
                                _delivery = 'pickup';
                              });
                            }),
                        title: Text(
                          'Pick up',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: constraint.maxHeight * .2),
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
                SizedBox(height: constraint.maxHeight * .02),
                MainButton(
                  label: 'Complete payment',
                  color: Theme.of(context).accentColor,
                  padding: constraint.maxHeight * 0.025,
                  onpressed: () => _validation(
                    name: details['username'],
                    address: details['address'],
                    phone: details['mobile'],
                    cost: cart.cartTotalPrice,
                    delivery: _delivery,
                    payment: payment,
                    cart: cart,
                    auth: auth,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: Colors.black45,
    toastLength: Toast.LENGTH_LONG,
  );
}
