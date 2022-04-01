import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionActiveStream extends StatelessWidget {
  buildSubscriptions(LinkFiveActiveProducts activeProducts) {
    return activeProducts.planList
        .map((data) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id: ${data.productId}"),
                  Text("    planId: ${data.planId}"),
                  Text("    rootId: ${data.rootId}"),
                  Text("    endDate: ${data.endDate}"),
                  Text("    familyName: ${data.familyName}"),
                  Text("    storeType: ${data.storeType}"),
                  Text("    isTrial: ${data.isTrial}")
                ],
              ),
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
              var activeProducts = snapshot.data;
              if (activeProducts != null) {
                return Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Text("Active Subscriptions:",
                          style: Theme.of(context).textTheme.headline6),
                      ...buildSubscriptions(activeProducts)
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
  buildSubscriptions(LinkFiveActiveProducts activeProducts) {
    return activeProducts.planList
        .map((data) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Id: ${data.productId}"),
                  Text("    planId: ${data.planId}"),
                  Text("    rootId: ${data.rootId}"),
                  Text("    endDate: ${data.endDate}"),
                  Text("    familyName: ${data.familyName}"),
                  Text("    storeType: ${data.storeType}"),
                  Text("    isTrial: ${data.isTrial}")
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
            var activeProducts = linkFiveProvider.activeProducts;
            if (activeProducts != null) {
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Text("Active Subscriptions:",
                        style: Theme.of(context).textTheme.headline6),
                    ...buildSubscriptions(activeProducts)
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              );
            }
            return Center(child: Text('Nothing found...'));
          },
        ));
  }
}
