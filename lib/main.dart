import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

//void main() => runApp(MyApp());
void main() {
  //BELOW IS ONE WAY TO SETUP ORIENTATION IN APP
  /*
  //this is to ENSURE SYSCHROME is INIT
  WidgetsFlutterBinding.ensureInitialized();
    //this is to set ALLOWED ORIENTATIONS

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  */

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      theme: ThemeData(
        //swatch: color group (gradiant)
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 'a1',
    //   title: 'Groceries',
    //   amount: 99.23,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'a2',
    //   title: 'Haircut',
    //   amount: 22.50,
    //   date: DateTime.now(),
    // ),
  ];
  //THIS VARIABLE MUST EXIST IN A STATEFUL WIDGET
  bool _showChart = false;

  //this is for chart ONLY
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((thisTrans) {
      return thisTrans.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((thisTrans) {
        return thisTrans.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    //start appbar variable
    final appBar = AppBar(
      title: Text(
        'Expense App',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add), //ac_unit is pretty cool under Icons.xyz
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    //end appbar variable
    final txtListWidget = Container(
      //media query CONTAINER
      child: TransactionList(_userTransactions, _deleteTransaction),
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //to handle chart in landscape mode:
            //special list if statememnt in DART v2.2.2
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val; //val is either bool true or false
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                  //media query CONTAINER
                  child: Chart(_recentTransactions),
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      .3), //30%
            if (!isLandscape) txtListWidget,

            if (isLandscape)
              _showChart
                  ? Container(
                      //media query CONTAINER
                      child: Chart(_recentTransactions),
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          .7) //70%
                  : txtListWidget, //variable holding list of trans
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //this is btn on bottom of screen
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
