import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases_example/provider/linkfive_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionActiveStream extends StatelessWidget {
  buildSubscriptions(LinkFiveActiveSubscriptionData subscriptionData) {
    return subscriptionData.subscriptionList
        .map((data) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id: ${data.sku}"),
                  Text("    PurchaseID: ${data.purchaseId}"),
                  Text("    Purchased: ${data.transactionDate}"),
                  Text("    Valid until: ${data.validUntilDate}"),
                  Text("    familyName: ${data.familyName}"),
                  Text("    skus: ${data.sku}"),
                  Text("    isExpired: ${data.isExpired}")
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
                      Text("Active Subscriptions:", style: Theme.of(context).textTheme.headline6),
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

class SubscriptionActiveProvider extends StatelessWidget {
  buildSubscriptions(LinkFiveActiveSubscriptionData subscriptionData) {
    return subscriptionData.subscriptionList
        .map((data) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id: ${data.sku}"),
                  Text("    PurchaseID: ${data.purchaseId}"),
                  Text("    Purchased: ${data.transactionDate}"),
                  Text("    Valid until: ${data.validUntilDate}"),
                  Text("    familyName: ${data.familyName}"),
                  Text("    skus: ${data.sku}"),
                  Text("    isExpired: ${data.isExpired}")
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Consumer<LinkFiveProvider>(
          builder: (_, linkFiveProvider, __) {
            if (linkFiveProvider.linkFiveResponseData != null) {
              var subscriptionData = linkFiveProvider.linkFiveActiveSubscriptionData;
              if (subscriptionData != null) {
                return Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Text("Active Subscriptions:", style: Theme.of(context).textTheme.headline6),
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
