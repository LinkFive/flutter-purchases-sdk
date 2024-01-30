import 'package:example_local/subscriptions/upgrade_downgrade_buttons.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class ProductActiveStream extends StatelessWidget {
  buildPlans(LinkFiveActiveProducts activeProducts) {
    return activeProducts.planList
        .map((activePlan) => Card(
              child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Product: ${activePlan.toString()}"), UpgradeDowngradeButtons(activePlan)],
                  )),
            ))
        .toList();
  }
  buildOneTimePurchases(LinkFiveActiveProducts activeProducts) {
    return activeProducts.oneTimePurchaseList
        .map((activePlan) => Card(
      child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Product: ${activePlan.toString()}")],
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
              var activeProducts = snapshot.data;
              if (activeProducts != null) {
                return Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Text("Active Plans:", style: Theme.of(context).textTheme.bodyMedium),
                      ...buildPlans(activeProducts),
                      Text("Active OneTimePurchases:", style: Theme.of(context).textTheme.bodyMedium),
                      ...buildOneTimePurchases(activeProducts)
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
