import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class SubscriptionButton extends StatelessWidget {
  final LinkFiveProductDetails linkFiveProductDetails;

  SubscriptionButton({required this.linkFiveProductDetails});

  onSubscriptionPressed() {
    LinkFivePurchases.purchase(linkFiveProductDetails.productDetails);
  }

  String getSubscriptionPeriod() {
    if (linkFiveProductDetails.productDetails is GooglePlayProductDetails) {
      return getSubscriptionPeriodGoogle(
          linkFiveProductDetails.productDetails as GooglePlayProductDetails);
    }
    return "-";
  }

  String getSubscriptionPeriodGoogle(GooglePlayProductDetails productDetails) {
    switch (productDetails.skuDetails.subscriptionPeriod) {
      case "P1W":
        return "1 Week";
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
          children: [
            Text(getSubscriptionPeriod()),
            Text(linkFiveProductDetails.productDetails.price)
          ],
        ),
      ),
    );
  }
}
