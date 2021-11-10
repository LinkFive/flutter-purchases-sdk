import 'package:example_local/subscriptions/subscription_button.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';

class SubscriptionOfferingStream extends StatelessWidget {
  buildSubscriptionButtons(LinkFiveSubscriptionData subscriptionData) {
    return subscriptionData.linkFiveSkuData
        .map((data) => SubscriptionButton(linkFiveProductDetails: data))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveSubscriptionData?>(
          stream: LinkFivePurchases.listenOnSubscriptionData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var subscriptionData = snapshot.data;
              if (subscriptionData != null) {
                return Column(
                  children: [
                    Row(
                      children: buildSubscriptionButtons(subscriptionData),
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    )
                  ],
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}
