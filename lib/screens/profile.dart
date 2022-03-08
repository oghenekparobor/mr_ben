import 'dart:convert';

import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/screens/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { card, bank, paypal }

class Profile extends StatefulWidget {
  static const route = '/profile';
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PaymentMethod _paymentMethod = PaymentMethod.card;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    var details = json.decode(auth.userDetail) as Map<String, dynamic>;

    return Scaffold(
      // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => ListView(
            children: [
              Text(
                'Information',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Image.asset('assets/images/avatar.jpg'),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${details['username']}',
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${auth.email}',
                            maxLines: 1,
                            softWrap: true,
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${details['mobile']}',
                            maxLines: 1,
                            softWrap: true,
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${details['address']}',
                            maxLines: 3,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(ProfileEdit.route),
                    ),
                  ],
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Text(
                'Payment method',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Radio(
                          value: PaymentMethod.bank,
                          groupValue: _paymentMethod,
                          onChanged: (PaymentMethod value) {
                            setState(() {
                              _paymentMethod = value;
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
                                borderRadius: BorderRadius.circular(5)),
                            child: FaIcon(
                              FontAwesomeIcons.university,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Bank account',
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
            ],
          ),
        ),
      ),
    );
  }
}
