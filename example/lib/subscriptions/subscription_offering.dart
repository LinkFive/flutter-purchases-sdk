import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases_example/provider/linkfive_provider.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_button.dart';
import 'package:provider/provider.dart';

class SubscriptionOfferingStream extends StatelessWidget {

  buildSubscriptionButtons(LinkFiveSubscriptionData subscriptionData) {
    return subscriptionData.linkFiveSkuData.map((data) => SubscriptionButton(linkFiveProductDetails: data)).toList();
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
            if(subscriptionData != null) {
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
      )
    );
  }
}
class SubscriptionOfferingProvider extends StatelessWidget {

  buildSubscriptionButtons(LinkFiveSubscriptionData subscriptionData) {
    return subscriptionData.linkFiveSkuData.map((data) => SubscriptionButton(linkFiveProductDetails: data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
        child: Consumer<LinkFiveProvider>(
          builder: (_, linkFiveProvider, __) {
            if (linkFiveProvider.linkFiveSubscriptionData != null) {
            var subscriptionData = linkFiveProvider.linkFiveSubscriptionData;
            if(subscriptionData != null) {
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
      )
    );
  }
}
