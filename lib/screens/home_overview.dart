import 'dart:async';

import 'package:Mr_Ben/auth/get_started.dart';
import 'package:Mr_Ben/models/category.dart';
import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/providers/cart.dart';
import 'package:Mr_Ben/screens/cart_screen.dart';
import 'package:Mr_Ben/screens/favorite_screen.dart';
import 'package:Mr_Ben/screens/home.dart';
import 'package:Mr_Ben/screens/offers.dart';
import 'package:Mr_Ben/screens/orders_screen.dart';
import 'package:Mr_Ben/screens/profile.dart';
import 'package:Mr_Ben/screens/transaction_history.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class HomeOverview extends StatefulWidget {
  static const route = '/home-overview';
  const HomeOverview({Key key}) : super(key: key);

  @override
  _HomeOverviewState createState() => _HomeOverviewState();
}

class _HomeOverviewState extends State<HomeOverview> {
  var _current = 0;
  var softkodes = false;

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  double radius = 0;

  void popDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;

      radius = 0;
    });
  }

  void launchWebsite() async {
    const url = 'https://google.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  void launchMail() async {
    const url = 'mailto:mrben@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  void launchSoftkodes() async {
    const url = 'http://coffeestudio.tech';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot launch $url';
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      PermissionStatus permission =
          await LocationPermissions().checkPermissionStatus();

      if (permission == PermissionStatus.denied) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Permission Request'),
            content: Text(
                'Open Settings -> Permissions -> Location -> "Allow all the time". \nSo that app can function properly'),
            actions: [
              FlatButton(
                onPressed: () async {
                  await LocationPermissions().openAppSettings();
                  Navigator.of(context).pop();
                },
                child: Text('Go to settings'),
              ),
            ],
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = ModalRoute.of(context).settings.arguments;
    List<dynamic> views = [
      AppHome(categories: categories),
      FavoriteScreen(),
      Profile(),
      TransactionHistory(),
    ];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var auth = Provider.of<Auth>(context, listen: false);
    var cart = Provider.of<Cart>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      onTap: auth.isAuth
                          ? () {
                              Navigator.of(context)
                                  .pushNamed(OrdersScreen.route);
                              popDrawer();
                            }
                          : () {
                              Navigator.of(context).pushNamed(GetStarted.route);
                              popDrawer();
                            },
                      leading: Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: width * .15,
                        right: width * 0.45,
                      ),
                      child: Divider(color: Colors.white),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(OffersAndPromo.route);
                        popDrawer();
                      },
                      leading: Icon(
                        Icons.label,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Offers & promo',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: width * .15,
                        right: width * 0.45,
                      ),
                      child: Divider(color: Colors.white),
                    ),
                    ListTile(
                      onTap: () {
                        launchWebsite();
                        popDrawer();
                      },
                      leading: Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title: Text(
                        'About',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: width * .15,
                        right: width * 0.45,
                      ),
                      child: Divider(color: Colors.white),
                    ),
                    ListTile(
                      onTap: () {
                        launchMail();
                        popDrawer();
                      },
                      leading: Icon(
                        Icons.help,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Help',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: width * .15,
                        right: width * 0.45,
                      ),
                      child: Divider(color: Colors.white),
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: auth.isAuth
                    ? () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                        Provider.of<Auth>(context, listen: false).logout();
                        showToast('Logged out successful');
                      }
                    : () {
                        Navigator.of(context).pushNamed(GetStarted.route);
                        popDrawer();
                      },
                leading: Icon(
                  auth.isAuth ? Icons.logout : Icons.login,
                  color: Colors.white,
                ),
                title: Row(
                  children: [
                    Text(
                      auth.isAuth ? 'Sign-Out' : 'Sign-In',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () => launchSoftkodes(),
                child: Developers(),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.white24,
            ),
            duration: Duration(milliseconds: 200),
            transform: Matrix4.translationValues(
              width * 0.6,
              height * 0.15,
              0,
            )
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.436332 : 0),
            // ..rotateY(isDrawerOpen ? -0.15 : 0),
          ),
        ),
        GestureDetector(
          onTap: isDrawerOpen ? () => popDrawer() : null,
          child: AnimatedContainer(
            height: height,
            width: width,
            transform: Matrix4.translationValues(
              xOffset,
              yOffset,
              0,
            )
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.436332 : 0),
            duration: Duration(milliseconds: 400),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(246, 246, 249, 1),
                  elevation: 0,
                  iconTheme: Theme.of(context).iconTheme,
                  leading: isDrawerOpen
                      ? IconButton(
                          icon: Icon(Typicons.delete),
                          onPressed: () => popDrawer(),
                        )
                      : IconButton(
                          icon: Icon(Typicons.th_menu),
                          onPressed: () {
                            setState(() {
                              xOffset = width * 0.6;
                              yOffset = height * 0.15;
                              radius = 30;
                              scaleFactor = 0.75;
                              isDrawerOpen = true;
                            });
                          }),
                  actions: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      width: 40,
                      child: Stack(
                        children: [
                          IconButton(
                            icon: Icon(Typicons.shopping_cart),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(CartScreen.route),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 8),
                              width: 15,
                              height: 15,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: FittedBox(
                                child: Text(
                                  '${cart.cartSize}',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                body: views[_current],
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Typicons.home,
                          color: _current == 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _current = 0;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Typicons.heart,
                          color: _current == 1
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        onPressed: auth.isAuth
                            ? () {
                                setState(() {
                                  _current = 1;
                                });
                              }
                            : () => Navigator.of(context)
                                .pushNamed(GetStarted.route),
                      ),
                      IconButton(
                        icon: Icon(
                          Typicons.user,
                          color: _current == 2
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        onPressed: auth.isAuth
                            ? () {
                                setState(() {
                                  _current = 2;
                                });
                              }
                            : () => Navigator.of(context)
                                .pushNamed(GetStarted.route),
                      ),
                      IconButton(
                        icon: Icon(
                          Typicons.time,
                          color: _current == 3
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        onPressed: auth.isAuth
                            ? () {
                                setState(() {
                                  _current = 3;
                                });
                              }
                            : () => Navigator.of(context)
                                .pushNamed(GetStarted.route),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Developers extends StatefulWidget {
  Developers();

  @override
  _DevelopersState createState() => _DevelopersState();
}

class _DevelopersState extends State<Developers> {
  var softkodes = false;

  void collaboration() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        softkodes = !softkodes;
      });
    });
  }

  @override
  void initState() {
    collaboration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        softkodes ? 'Designed by Softkodes' : 'Developed by Coffee.',
        style: TextStyle(color: Colors.white60, fontSize: 15),
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
