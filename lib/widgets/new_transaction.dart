import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  DateTime _selectedDate;
  final amountController = TextEditingController();

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredExpenseItem = titleController.text;

    final enteredAmount = double.parse(amountController.text);
    if (enteredExpenseItem.isEmpty ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return;
    }
    widget.addTx(
      titleController.text,
      double.parse(amountController.text),
      _selectedDate,
    );
    //makes text/digit input dialog
    //automatically go away when action
    //happens
    Navigator.of(context).pop();
  }

  void _doDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950), //cant go before 1950
            lastDate: DateTime.now()) //cant go past today
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //this allows the user to scroll while typing 
    //in input dialog
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: titleController,
                onSubmitted: (_) =>
                    submitData(), //underscore (_) is a dummy value that is never used
                decoration: InputDecoration(
                  labelText: 'Expense Item',
                ),
              ),
              TextField(
                controller: amountController,
                onSubmitted: (_) => submitData(),
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Selected'
                        : DateFormat.yMd().format(_selectedDate)),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _doDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: submitData,
                child: Text('Add Item'),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
