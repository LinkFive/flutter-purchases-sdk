import 'package:example_local/subscriptions/upgrade_downgrade_buttons.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';

class SubscriptionActiveStream extends StatelessWidget {
  buildSubscriptions(LinkFiveActiveSubscriptionData subscriptionData) {
    return subscriptionData.subscriptionList
        .map((data) => Card(
              child: Container(
                margin: EdgeInsets.all(8),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id: ${data.sku}"),
                  Text("    PurchaseID: ${data.purchaseId}"),
                  Text("    Purchased: ${data.transactionDate}"),
                  Text("    Valid until: ${data.validUntilDate}"),
                  Text("    familyName: ${data.familyName}"),
                  Text("    skus: ${data.sku}"),
                  Text("    isExpired: ${data.isExpired}"),
                  UpgradeDowngradeButtons(data)
                ],
              )),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveActiveSubscriptionData?>(
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
