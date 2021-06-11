import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_button.dart';

class SubscriptionOffering extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SubscriptionOfferingState();
}

class _SubscriptionOfferingState extends State<SubscriptionOffering> with WidgetsBindingObserver {


  buildSubscriptionButtons(LinkFiveSubscriptionData subscriptionData) {
    return subscriptionData.linkFiveSkuData.map((data) => SubscriptionButton(linkFiveSkuData: data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: StreamBuilder(
        stream: LinkFivePurchases.linkFiveSubscription(),
        builder: (BuildContext context, AsyncSnapshot<LinkFiveSubscriptionData> snapshot) {
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
