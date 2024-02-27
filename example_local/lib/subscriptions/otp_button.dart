import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class OTPButton extends StatelessWidget {
  final LinkFiveProductDetails linkFiveProductDetails;

  const OTPButton({required this.linkFiveProductDetails});

  onPressed() {
    LinkFivePurchases.purchase(linkFiveProductDetails.productDetails);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("One Time Purchase id: ${linkFiveProductDetails.productDetails.id}"),
            Table(children: [
              TableRow(children: [
                TableCell(child: Text('PRICE', style: Theme.of(context).textTheme.bodyLarge)),
              ]),
              TableRow(children: [
                TableCell(child: Text(linkFiveProductDetails.oneTimePurchasePrice.formattedPrice)),
              ])
            ]),
          ],
        ),
      ),
    );
  }
}
