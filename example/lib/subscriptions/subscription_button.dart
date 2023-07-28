import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchases_intl/extensions/duration_extension.dart';
import 'package:in_app_purchases_intl/helper/paywall_helper.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class SubscriptionButton extends StatelessWidget {
  final LinkFiveProductDetails linkFiveProductDetails;

  SubscriptionButton({required this.linkFiveProductDetails});

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
          children: [
            Text(linkFiveProductDetails.pricingPhases.first.billingPeriod.iso8601
                .fromIso8601(PaywallL10NHelper.of(context))
                .durationText),
            Text(linkFiveProductDetails.productDetails.price)
          ],
        ),
      ),
    );
  }
}
