import 'package:Mr_Ben/models/meal.dart';
import 'package:Mr_Ben/providers/meals.dart';
import 'package:Mr_Ben/views/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ShowMore extends StatefulWidget {
  static const route = '/showmore';
  const ShowMore({Key key}) : super(key: key);

  @override
  _ShowMoreState createState() => _ShowMoreState();
}

class _ShowMoreState extends State<ShowMore> {
  // String category;
  List<Meal> cat;

  void loading(BuildContext context, String category) async {
    Provider.of<Meals>(context, listen: false).loadCategorizedMeals(category);
    cat = Provider.of<Meals>(context, listen: false).cmeals;
  }

  @override
  Widget build(BuildContext context) {
    var category = ModalRoute.of(context).settings.arguments as String;
    loading(context, category);

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
          '',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 18,
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
        child: Column(
          children: [
            SizedBox(height: 15),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .55,
                  ),
                  children: [
                    for (int i = 0; i < cat.length; i++)
                      ProductItem(
                        horizintal: 5,
                        vertical: 5,
                        meal: cat[i],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
