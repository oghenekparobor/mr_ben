import 'package:flutter/material.dart';

class OffersAndPromo extends StatelessWidget {
  static const route = '/offers_promo';
  const OffersAndPromo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(246, 246, 249, 1),
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: constraint.maxHeight * .02),
              Text(
                'My Offers',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ohh snap! No offers yet',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mr Ben Barbeque doesn\'t have any offers \nyet please check again.',
                      style: TextStyle(fontSize: 17),
                    ),
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
