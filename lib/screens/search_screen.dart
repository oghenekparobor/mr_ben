import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/product_item.dart';
import '../providers/meals.dart';

class Search extends StatelessWidget {
  static const route = '/search';
  const Search({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var search = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          '$search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(246, 246, 249, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: FutureBuilder(
          future: Provider.of<Meals>(context, listen: false).searchMeal(search),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            } else {
              return Consumer<Meals>(
                builder: (ctx, meal, child) => meal.searchedMeals.length < 1
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/search.png',
                              // width: 150,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Item not found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Try searching the item with a \ndifferent keyword.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 15),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Found ${meal.searchedMeals.length} results',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: .55,
                                ),
                                children: [
                                  for (int i = 0;
                                      i < meal.searchedMeals.length;
                                      i++)
                                    ProductItem(
                                      horizintal: 5,
                                      vertical: 5,
                                      meal: meal.searchedMeals[i],
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}
