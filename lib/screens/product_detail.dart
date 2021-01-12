import 'package:Mr_Ben/models/meal.dart';
import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/providers/cart.dart';
import 'package:Mr_Ben/providers/meals.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const route = '/product-detail';
  const ProductDetail({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final Meal meal = ModalRoute.of(context).settings.arguments;
    var auth = Provider.of<Auth>(context).userId;
    Provider.of<Meals>(context).showFav(meal.id, auth);

    List<String> imgList = [
      if (meal.picture1.endsWith('.png') ||
          meal.picture1.endsWith('.jpg') ||
          meal.picture1.endsWith('.jpeg'))
        meal.picture1,
      if (meal.picture2.endsWith('.png') ||
          meal.picture2.endsWith('.jpg') ||
          meal.picture2.endsWith('.jpeg'))
        meal.picture2,
      if (meal.picture3.endsWith('.png') ||
          meal.picture3.endsWith('.jpg') ||
          meal.picture3.endsWith('.jpeg'))
        meal.picture3,
      if (meal.picture4.endsWith('.png') ||
          meal.picture4.endsWith('.jpg') ||
          meal.picture4.endsWith('.jpeg'))
        meal.picture4,
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(246, 246, 249, 1),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Consumer<Meals>(
              builder: (ctx, meals, child) => IconButton(
                icon: Icon(
                  meals.favStatus ? Icons.favorite : Icons.favorite_outline,
                ),
                onPressed: () {
                  meals.addFav(meal.id, auth);
                },
              ),
            ),
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        child: LayoutBuilder(
          builder: (ctx, constraint) => SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: constraint.maxHeight * .5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Carousel(
                      animationCurve: Curves.easeOutQuad,
                      dotIncreasedColor: Theme.of(context).primaryColor,
                      dotPosition: DotPosition.bottomRight,
                      images: imgList
                          .map((e) => Container(
                                child: FancyShimmerImage(
                                  imageUrl: e,
                                  boxFit: BoxFit.cover,
                                  shimmerBackColor: Colors.grey,
                                  shimmerBaseColor: Colors.grey.shade100,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: constraint.maxHeight * .03),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${meal.title}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(height: constraint.maxHeight * .02),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'N${meal.price}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: constraint.maxHeight * .03),
                meal.description.isEmpty
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Details',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ),
                SizedBox(height: constraint.maxHeight * .02),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${meal.description}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                // SizedBox(height: constraint.maxHeight * .03),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text(
                //     'Ingredients',
                //     style: TextStyle(
                //       fontSize: 17,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                // SizedBox(height: constraint.maxHeight * .02),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text(
                //     '',
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.normal,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),
                SizedBox(height: 100),
                Container(
                  width: double.infinity,
                  child: AddToCart(
                    meal: meal,
                    padding: constraint.maxHeight * 0.025,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddToCart extends StatefulWidget {
  const AddToCart({
    this.meal,
    this.padding,
  });
  final Meal meal;
  final double padding;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  var _isAdded = false;
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    return Consumer<Meals>(
      builder: (ctx, meals, child) => RaisedButton(
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: widget.padding),
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () async {
          setState(() {
            _isAdded = true;
          });
          await cart.addToCart(
            mealid: widget.meal.id,
            quantity: '${cart.choosenQuantiy}',
          );
          await cart.addCartItem(
            price: widget.meal.price,
            productId: '${widget.meal.id}',
            quantity: cart.choosenQuantiy,
            title: widget.meal.title,
            image: widget.meal.picture1,
          );
          setState(() {
            _isAdded = false;
          });
          Navigator.of(context).pop(true);
        },
        child: _isAdded
            ? CircularProgressIndicator(
                strokeWidth: 1,
                backgroundColor: Colors.white,
              )
            : Text(
                'Add to cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
