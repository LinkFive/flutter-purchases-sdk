import 'package:example_local/subscriptions/upgrade_downgrade_buttons.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class SubscriptionActiveStream extends StatelessWidget {
  buildSubscriptions(LinkFiveActiveProducts activeProducts) {
    return activeProducts.planList
        .map((activePlan) => Card(
              child: Container(
                margin: EdgeInsets.all(8),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Product: ${activePlan.toString()}"),
                  UpgradeDowngradeButtons(activePlan)
                ],
              )),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveActiveProducts>(
          stream: LinkFivePurchases.activeProducts,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              var subscriptionData = snapshot.data;
              if (subscriptionData != null) {
                return Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Text("Active Subscriptions:",
                          style: Theme.of(context).textTheme.headline6),
                      ...buildSubscriptions(subscriptionData)
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}
