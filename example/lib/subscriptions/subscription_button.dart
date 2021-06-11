import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';

class SubscriptionButton extends StatelessWidget {
  final LinkFiveSkuData linkFiveSkuData;

  SubscriptionButton({required this.linkFiveSkuData});

  onSubscriptionPressed() {
    print("press");
  }

  String getSubscriptionPeriod() {
    switch (linkFiveSkuData.skuDetails.subscriptionPeriod) {
      case "P1M":
        return "1 Month";
      case "P3M":
        return "3 Months";
      case "P6M":
        return "6 Months";
      case "P1Y":
        return "1 Year";
    }
    return "unknown";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onSubscriptionPressed,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(getSubscriptionPeriod()), Text(linkFiveSkuData.skuDetails.price)],
        ),
      ),
    );
  }
}
