import 'package:Mr_Ben/models/meal.dart';
import 'package:Mr_Ben/screens/product_detail.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: Colors.black45,
    toastLength: Toast.LENGTH_LONG,
  );
}

class ProductItem extends StatelessWidget {
  static const route = '/product-item';
  ProductItem({
    this.horizintal = 15,
    this.vertical = 10,
    this.meal,
  });
  final double vertical;
  final double horizintal;
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(
        ProductDetail.route,
        arguments: meal,
      )
          .then((value) {
        if (value != null) showToast('Added to Cart');
      }),
      child: Container(
        alignment: Alignment.topCenter,
        width: 220,
        height: 321,
        margin:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizintal),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Container(
            child: Stack(
              children: [
                Container(
                  width: constraint.maxWidth,
                  height: constraint.maxHeight,
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Hero(
                            tag: '${meal.id}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration:
                                    BoxDecoration(boxShadow: [BoxShadow()]),
                                child: FancyShimmerImage(
                                  imageUrl: '${meal.picture1}',
                                  boxFit: BoxFit.cover,
                                  shimmerBackColor: Colors.grey,
                                  shimmerBaseColor: Colors.grey.shade100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${meal.title}',
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: constraint.maxHeight * 0.03),
                            Text(
                              'N${meal.price}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
