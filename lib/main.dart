import 'package:Mr_Ben/auth/forget.dart';
import 'package:Mr_Ben/auth/get_started.dart';
import 'package:Mr_Ben/auth/home.dart';
import 'package:Mr_Ben/auth/wait.dart';
import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/providers/cart.dart';
import 'package:Mr_Ben/providers/categories.dart';
import 'package:Mr_Ben/providers/meals.dart';
import 'package:Mr_Ben/providers/orders.dart';
import 'package:Mr_Ben/screens/address.dart';
import 'package:Mr_Ben/screens/cart_screen.dart';
import 'package:Mr_Ben/screens/delivery.dart';
import 'package:Mr_Ben/screens/finished.dart';
import 'package:Mr_Ben/screens/history_view.dart';
import 'package:Mr_Ben/screens/home_overview.dart';
import 'package:Mr_Ben/screens/offers.dart';
import 'package:Mr_Ben/screens/order_view.dart';
import 'package:Mr_Ben/screens/orders_screen.dart';
import 'package:Mr_Ben/screens/pay.dart';
import 'package:Mr_Ben/screens/product_detail.dart';
import 'package:Mr_Ben/screens/profile.dart';
import 'package:Mr_Ben/screens/profile_edit.dart';
import 'package:Mr_Ben/screens/search_screen.dart';
import 'package:Mr_Ben/screens/show_more.dart';
import 'package:Mr_Ben/screens/verify_auth.dart';
import 'package:Mr_Ben/providers/history.dart' as his;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Categories()),
        ChangeNotifierProvider.value(value: Meals()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
        ChangeNotifierProvider.value(value: his.History()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mr Ben',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.grey,
            primaryColor: Color.fromRGBO(55, 55, 55, 1),
            accentColor: Color.fromRGBO(251, 17, 28, 1),
            fontFamily: 'SF Pro',
            backgroundColor: Colors.white,
          ),
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : Home(),
                ),
          routes: {
            GetStarted.route: (ctx) => GetStarted(),
            HomeOverview.route: (ctx) => HomeOverview(),
            Profile.route: (ctx) => Profile(),
            ProductDetail.route: (ctx) => ProductDetail(),
            Search.route: (ctx) => Search(),
            Payment.route: (ctx) => Payment(),
            Delivery.route: (ctx) => Delivery(),
            ForgetPassword.route: (ctx) => ForgetPassword(),
            CartScreen.route: (ctx) => CartScreen(),
            ProfileEdit.route: (ctx) => ProfileEdit(),
            OrdersScreen.route: (ctx) => OrdersScreen(),
            OffersAndPromo.route: (ctx) => OffersAndPromo(),
            OrderView.route: (ctx) => OrderView(),
            HistoryView.route: (ctx) => HistoryView(),
            ShowMore.route: (ctx) => ShowMore(),
            Finish.route: (ctx) => Finish(),
            WaitScreen.route: (ctx) => WaitScreen(),
            Address.route: (ctx) => Address(),
          },
        ),
      ),
    );
  }
}
