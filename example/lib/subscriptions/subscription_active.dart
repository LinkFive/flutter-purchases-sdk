import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';

class SubscriptionActive extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SubscriptionActiveState();
}

class _SubscriptionActiveState extends State<SubscriptionActive>
    with WidgetsBindingObserver {
  buildSubscriptions(LinkFiveActiveSubscriptionData subscriptionData) {
    return subscriptionData.subscriptionList
        .map((data) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id: ${data.verifiedReceipt?.sku}"),
                  Text("    PurchaseID: ${data.verifiedReceipt?.purchaseId}"),
                  Text(
                      "    Purchased: ${data.verifiedReceipt?.transactionDate}"),
                  Text(
                      "    Valid until: ${data.verifiedReceipt?.validUntilDate}"),
                  Text("    familyName: ${data.familyName}"),
                  Text("    skus: ${data.sku}"),
                  Text("    isExpired: ${data.verifiedReceipt?.isExpired}")
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveActiveSubscriptionData?>(
          stream: LinkFivePurchases.listenOnActiveSubscriptionData(),
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
