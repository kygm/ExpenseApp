import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String dayLabel;
  final double spendingAmount;
  final double spendingPercentOfAmount;

  ChartBar(this.dayLabel, this.spendingAmount, this.spendingPercentOfAmount);

  @override
  Widget build(BuildContext context) {
    //takes in context and constraints.
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            Container(
              //constraints is the widgets properties. maxHeight and maxWidth
              //are methods in the constraints class
              height: constraints.maxHeight * .15,
              child: FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * .05,
            ),
            Container(
              height: constraints.maxHeight * .5,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPercentOfAmount,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * .05,
            ),
            Container(
                child: FittedBox(child: Text(dayLabel)),
                height: constraints.maxHeight * .15),
          ],
        );
      },
    );
  }
}
