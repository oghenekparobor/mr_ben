import 'package:Mr_Ben/auth/sign_in.dart';
import 'package:Mr_Ben/auth/sign_up.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  static const route = '/get_started';
  const GetStarted({Key key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  List<dynamic> screens = [
    SignIn(),
    SignUp(),
  ];
  var _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * .74,
                  width: double.infinity,
                  child: screens[_current],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 40,
                          ),
                          child: Image.asset('assets/images/logo2.png'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _current = 0;
                                });
                              },
                              child: Container(
                                width: 120,
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _current == 0
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _current = 1;
                                });
                              },
                              child: Container(
                                width: 120,
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _current == 1
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Sign-up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
