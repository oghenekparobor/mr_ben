import 'package:Mr_Ben/screens/history_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history.dart' as histProvider;
import '../providers/auth.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatelessWidget {
  static const route = '/transactions';
  const TransactionHistory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context).userId;
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 249, 1),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (ctx, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shopping\nhistory',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: constraint.maxHeight * .02),
              Expanded(
                child: FutureBuilder(
                  future:
                      Provider.of<histProvider.History>(context, listen: false)
                          .fetchOrdersOnline(int.parse(auth)),
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    } else {
                      if (dataSnapshot.data.toString().isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                        return Consumer<histProvider.History>(
                          builder: (ctx, history, child) => history
                                      .transactions.length <
                                  1
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Image.asset(
                                        'assets/images/history.png',
                                        height: 150,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'No history yet',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'No transactions found!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView(
                                  children: [
                                    for (int i = 0;
                                        i < history.transactions.length;
                                        i++)
                                      Container(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(
                                                HistoryView.route,
                                                arguments:
                                                    history.transactions[i],
                                              ),
                                              title: Text(history
                                                  .transactions[i].orderID),
                                              subtitle: Text(
                                                  '${DateFormat.yMMMEd().format(DateTime.parse(history.transactions[i].dateTime))}'),
                                              trailing: FittedBox(
                                                child: Text(
                                                  'N${history.transactions[i].amount.toStringAsFixed(0)}',
                                                ),
                                              ),
                                            ),
                                            Divider(),
                                          ],
                                        ),
                                      )
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
