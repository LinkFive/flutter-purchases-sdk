import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class SubscriptionButton extends StatelessWidget {
  final LinkFiveProductDetails linkFiveProductDetails;

  const SubscriptionButton({required this.linkFiveProductDetails});

  onSubscriptionPressed() {
    LinkFivePurchases.purchase(linkFiveProductDetails.productDetails);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubscriptionPressed,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("id: ${linkFiveProductDetails.productDetails.id}"),
            Table(
              children: [
                TableRow(children: [
                  TableCell(child: Text('PHASE', style: Theme.of(context).textTheme.bodyLarge)),
                  TableCell(child: Text('PRICE', style: Theme.of(context).textTheme.bodyLarge)),
                  TableCell(child: Text('RECURRENCE', style: Theme.of(context).textTheme.bodyLarge)),
                ]),
                for (final phase in linkFiveProductDetails.pricingPhases)
                  TableRow(children: [
                    TableCell(child: Text(phase.billingPeriod.toString())),
                    TableCell(child: Text(phase.formattedPrice)),
                    TableCell(child: Text(phase.recurrence.toString())),
                  ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
