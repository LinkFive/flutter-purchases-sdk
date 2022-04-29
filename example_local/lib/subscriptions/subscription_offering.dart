import 'package:example_local/subscriptions/subscription_button.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class SubscriptionOfferingStream extends StatelessWidget {
  buildSubscriptionButtons(LinkFiveProducts linkFiveProducts) {
    return linkFiveProducts.productDetailList
        .map((data) => SubscriptionButton(linkFiveProductDetails: data))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveProducts>(
          stream: LinkFivePurchases.products,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var subscriptionData = snapshot.data;
              if (subscriptionData != null) {
                return Column(
                  children: [
                    Row(
                      children: buildSubscriptionButtons(subscriptionData),
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),

                  ],
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}
