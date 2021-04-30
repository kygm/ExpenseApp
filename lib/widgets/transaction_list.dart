import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx; //passing in delete function from main

  TransactionList(this.transactions,
      this.deleteTx); //adding delete function as parameter in const.

  @override
  Widget build(BuildContext context) {
    return Container(
      //media query pulls scrn h x w
      //height: MediaQuery.of(context).size.height * 0.6, //this is scrn h * % of scrn to disp
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text('No Expense Items Yet'),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: constraints.maxHeight * .60, //60%
                    child: Image.asset(
                      'images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          : ListView(
              children: transactions.map((tran) {
                return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '\$${tran.amount.toStringAsFixed(2)}', //this is = to %.2f\n in java
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tran.title,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat.yMMMEd().format(tran.date),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      //if width of scrn is > 500, disp delete flatbtn, else disp iconbtn
                      MediaQuery.of(context).size.width > 460
                          ? FlatButton.icon(
                              icon: Icon(Icons.delete),
                              label: Text('Delete'),
                              onPressed: () => deleteTx(tran.id),
                              color: Theme.of(context).errorColor)
                          : IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () => deleteTx(tran
                                  .id), //delete handled here, passing in tran map id
                            )
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
