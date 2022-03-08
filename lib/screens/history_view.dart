import 'package:Mr_Ben/providers/history.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  static const route = '/history_view';
  const HistoryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoryItem orders =
        ModalRoute.of(context).settings.arguments as HistoryItem;
    var dat = DateFormat.yMMMEd().format(DateTime.parse(orders.dateTime));
    String status;

    if (orders.deliveryMethod == 'pickup' &&
        orders.available == 'Yes' &&
        orders.status == 'delivered') status = 'Order has been picked up';
    if (orders.deliveryMethod == 'door_delivery' &&
        orders.available == 'No' &&
        orders.status == 'delivered') status = 'Order has been delivered';

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
                    style: TextStyle(fontSize: 13, color: Colors.black54),
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
                                subtitle: Text('Cash or Card'),
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
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
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
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
