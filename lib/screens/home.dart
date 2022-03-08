import 'package:Mr_Ben/auth/wait.dart';
import 'package:Mr_Ben/models/category.dart';
import 'package:Mr_Ben/models/meal.dart';
import 'package:Mr_Ben/providers/meals.dart';
import 'package:Mr_Ben/screens/search_screen.dart';
import 'package:Mr_Ben/screens/show_more.dart';
import 'package:Mr_Ben/views/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AppHome extends StatefulWidget {
  AppHome({this.categories});
  final List<Category> categories;

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  var _current = 0;
  List<Meal> meals;
  String category;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => ListView(
            children: [
              SizedBox(height: 10),
              Text(
                'Great food\nfrom our grill',
                // 'BBQ is\nLifestyle',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: constraint.maxWidth * .02,
                ),
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(232, 232, 234, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    SizedBox(width: constraint.maxWidth * .04),
                    Icon(Icons.search),
                    SizedBox(width: constraint.maxWidth * .02),
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          if (value.isNotEmpty)
                            Navigator.of(context).pushNamed(
                              Search.route,
                              arguments: value,
                            );
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Container(
                height: constraint.maxHeight * .09,
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < widget.categories.length; i++)
                      GestureDetector(
                        onTap: () async {
                          await Provider.of<Meals>(context, listen: false)
                              .clearMeals();
                          setState(
                            () {
                              _current = i;
                              category = widget.categories[i].category;

                              Provider.of<Meals>(context, listen: false)
                                  .loadCategorizedMeals(category);
                            },
                          );
                        },
                        child: Container(
                          height: constraint.maxHeight * 0.09,
                          padding: EdgeInsets.symmetric(
                              horizontal: constraint.maxWidth * 0.03),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2,
                                color: _current == i
                                    ? Theme.of(context).accentColor
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          child: FittedBox(
                            child: Text(
                              widget.categories[i].category,
                              style: TextStyle(
                                fontSize: 17,
                                color: _current == i
                                    ? Theme.of(context).accentColor
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    ShowMore.route,
                    arguments: category,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'see more',
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: constraint.maxHeight * .03),
              Container(
                width: double.infinity,
                height: constraint.maxHeight * .52,
                child: FutureBuilder(
                  future: Provider.of<Meals>(context, listen: false)
                      .loadCategorizedMeals(
                          widget.categories[_current].category),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(strokeWidth: 1),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Center(
                        child: Text('No network'),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(WaitScreen.route);
                          },
                          child: Text('Try Again'),
                        );
                      } else {
                        return Consumer<Meals>(
                          builder: (ctx, meals, child) => ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(width: 50),
                              for (int i = 0; i < meals.cmeals.length; i++)
                                ProductItem(
                                  meal: meals.cmeals[i],
                                ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
