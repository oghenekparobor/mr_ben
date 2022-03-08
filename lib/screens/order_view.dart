import 'package:Mr_Ben/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderView extends StatelessWidget {
  static const route = '/order_view';
  const OrderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderItem orders = ModalRoute.of(context).settings.arguments as OrderItem;
    var dat = DateFormat.yMMMEd().format(DateTime.parse(orders.dateTime));
    String status;

    if (orders.deliveryMethod == 'pickup' && orders.available == 'Yes')
      status = 'Your order is available for pickup';
    if (orders.deliveryMethod == 'pickup' && orders.available == 'No')
      status = 'Please wait while we prepare your order';
    if (orders.deliveryMethod == 'door_delivery' && orders.available == 'No')
      status = 'Please wait while we prepare your order';
    if (orders.deliveryMethod == 'door_delivery' &&
        orders.available == 'Yes' &&
        orders.status == 'processed') status = 'Your order is on the way';
    if (orders.deliveryMethod == 'door_delivery' &&
        orders.available == 'Yes' &&
        orders.status == 'processing')
      status = 'Please wait while we prepare your order';

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 45,
              color: Colors.black38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ORDER NO: ${orders.orderID}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$dat',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('${orders.products.length} items'),
                                subtitle: Text(
                                    'N${orders.amount.toStringAsFixed(0)}'),
                              ),
                              ListTile(
                                title: Text('Status'),
                                subtitle: Text('$status'),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Payment'),
                                subtitle: Text('${orders.payment}'),
                              ),
                              ListTile(
                                title: Text('Delivery'),
                                subtitle: Text('${orders.deliveryMethod}'),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  if (orders.deliveryMethod == 'pickup') Divider(),
                  if (orders.deliveryMethod == 'pickup')
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup address',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Becky store, NNPC Junior Staff Club, Bendel Estate, Effurun, Delta state',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      await launch('tel:+2348126237218');
                    },
                    child: Text(
                      '08126237218',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      await launch('tel:+2347018805916');
                    },
                    child: Text(
                      '07018805916',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Address',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    orders.address,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerLeft,
              height: 45,
              color: Colors.black38,
              child: Text(
                'YOUR ORDERS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            for (int i = 0; i < orders.products.length; i++)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [BoxShadow()]),
                        child: Image.network(
                          '${orders.products[i].imageUrl}',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${orders.products[i].title}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'N${orders.products[i].price}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Divider(),
                          Text(
                            'Quantity: ${orders.products[i].quantity}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: MaterialButton(
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: orders.available == 'Yes'
                    ? null
                    : () async {
                        Provider.of<Orders>(context, listen: false)
                            .cancelOrder(int.parse(orders.id), orders.orderID)
                            .then((value) => Navigator.of(context).pop(true));
                      },
                child: Text(
                  'Cancel Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
