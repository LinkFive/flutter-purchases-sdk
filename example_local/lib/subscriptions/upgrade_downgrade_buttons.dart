import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class UpgradeDowngradeButtons extends StatelessWidget {
  final LinkFiveVerifiedReceipt oldPurchaseDetails;

  UpgradeDowngradeButtons(this.oldPurchaseDetails);

  Widget getButton(
      BuildContext context, LinkFiveProductDetails linkFiveProductDetails) {
    return ElevatedButton(
        onPressed: () {
          LinkFivePurchases.switchPlan(
              oldPurchaseDetails, linkFiveProductDetails.productDetails,
              prorationMode: ProrationMode.immediateWithTimeProration);
        },
        child: Text(
          "to ${linkFiveProductDetails.productDetails.id}",
          style:
              Theme.of(context).textTheme.caption?.apply(color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LinkFiveSubscriptionData?>(
        stream: LinkFivePurchases.products,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Column(
                    children: snapshot.data!.linkFiveSkuData
                        .map((e) => getButton(context, e))
                        .toList()));
          }
          return Container(
            child: Text("nothing to offer"),
          );
        });
  }
}
