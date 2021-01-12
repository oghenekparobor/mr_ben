import 'package:Mr_Ben/views/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals.dart';
import '../providers/auth.dart';

class FavoriteScreen extends StatelessWidget {
  static const route = '/favorites';
  const FavoriteScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false).userId;

    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My favorite\nfoods',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<Meals>(context, listen: false).getAllFav(
                    int.parse(auth),
                  ),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    } else {
                      if (snapshot.data.toString().isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/no_data.png',
                                width: 70,
                                height: 120,
                              ),
                              Text('No transaction history'),
                            ],
                          ),
                        );
                      } else {
                        return Consumer<Meals>(
                          builder: (ctx, meal, child) => meal.favMeals.length <
                                  1
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/no_data.png',
                                        width: 150,
                                      ),
                                      Text('No favorite meal found.'),
                                    ],
                                  ),
                                )
                              : GridView(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: .55,
                                  ),
                                  children: [
                                    for (int i = 0;
                                        i < meal.favMeals.length;
                                        i++)
                                      ProductItem(
                                        meal: meal.favMeals[i],
                                        horizintal: 5,
                                        vertical: 5,
                                      )
                                  ],
                                ),
                        );
                      }
                    }
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
