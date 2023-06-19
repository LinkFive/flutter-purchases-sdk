import 'package:example_local/subscriptions/subscription_button.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class SubscriptionOfferingStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveProducts>(
          stream: LinkFivePurchases.products,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var subscriptionData = snapshot.data;
              if (subscriptionData != null) {
                return ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: subscriptionData.productDetailList.length,
                  itemBuilder: (context, index) {
                    final productDetails = subscriptionData.productDetailList[index];
                    return SubscriptionButton(
                      linkFiveProductDetails: productDetails,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16);
                  },
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}
