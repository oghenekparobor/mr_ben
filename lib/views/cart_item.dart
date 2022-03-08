import 'package:Mr_Ben/providers/auth.dart';
import 'package:Mr_Ben/providers/cart.dart';
import 'package:Mr_Ben/providers/meals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final String cartId;
  final int quantity;
  final double price;
  final String mealid;
  final String title;
  final String image;

  CartItem({
    this.cartId,
    this.mealid,
    this.price,
    this.quantity,
    this.title,
    this.image,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int _current;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context).userId;
    Provider.of<Meals>(context).showFav(int.parse(widget.mealid), auth);
    _current = widget.quantity;

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      secondaryActions: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromRGBO(223, 44, 44, 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: FaIcon(FontAwesomeIcons.trashAlt, color: Colors.white),
            onPressed: () {
              Provider.of<Cart>(context, listen: false)
                  .removeItem(widget.mealid);
              Provider.of<Cart>(context, listen: false).deleteFromCart(
                mealid: int.parse(widget.mealid),
                quantity: '${widget.quantity}',
              );
            },
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 100,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                maxRadius: 35,
                backgroundImage: NetworkImage(
                  '${widget.image}',
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.title}',
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'N${widget.price}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              Container(
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.minus,
                        size: 8,
                        color: Colors.white,
                      ),
                      onPressed: _current < 2
                          ? null
                          : () {
                              setState(() {
                                _current -= 1;
                                Provider.of<Cart>(context, listen: false)
                                    .removeCartItem(
                                  image: widget.image,
                                  price: widget.price,
                                  productId: widget.mealid,
                                  quantity: 1,
                                );
                              });
                            },
                    ),
                    Text(
                      '$_current',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.plus,
                        size: 8,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _current += 1;
                          Provider.of<Cart>(context, listen: false).addCartItem(
                            image: widget.image,
                            price: widget.price,
                            productId: widget.mealid,
                            quantity: 1,
                          );
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HorizintalCounter extends StatefulWidget {
  const HorizintalCounter({this.quantity = 1});
  final int quantity;

  @override
  _HorizintalCounterState createState() => _HorizintalCounterState();
}

class _HorizintalCounterState extends State<HorizintalCounter> {
  @override
  Widget build(BuildContext context) {
    int _current = widget.quantity;

    return Container(
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.minus,
              size: 8,
              color: Colors.white,
            ),
            onPressed: _current < 2
                ? null
                : () {
                    setState(() {
                      _current -= 1;
                    });
                  },
          ),
          Text(
            '$_current',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.plus,
              size: 8,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _current += 1;
              });
            },
          )
        ],
      ),
    );
  }
}
