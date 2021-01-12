import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';

class Address extends StatelessWidget {
  static const route = '/address';
  const Address({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // height: 300,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: AddressSearchBox(
                country: 'Nigeria',
                onCleaned: () {
                  Navigator.of(context).pop();
                },
                hintText: 'Search your address',
                noResultsText: 'No address found',
                onDone: (dialogContext, point) {
                  Navigator.of(context).pop(point.address);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
