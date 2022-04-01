import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_button.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionOfferingStream extends StatelessWidget {
  buildSubscriptionButtons(LinkFiveProducts products) {
    return products.productDetailList
        .map((data) => SubscriptionButton(linkFiveProductDetails: data))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveProducts>(
          stream: LinkFivePurchases.products,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var products = snapshot.data;
              if (products != null) {
                return Column(
                  children: [
                    Row(
                      children: buildSubscriptionButtons(products),
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

class SubscriptionOfferingProvider extends StatelessWidget {
  buildSubscriptionButtons(LinkFiveProducts subscriptionData) {
    return subscriptionData.productDetailList
        .map((data) => SubscriptionButton(linkFiveProductDetails: data))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Consumer<LinkFiveProvider>(
          builder: (_, linkFiveProvider, __) {
            if (linkFiveProvider.products != null) {
              var subscriptionData = linkFiveProvider.products;
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
