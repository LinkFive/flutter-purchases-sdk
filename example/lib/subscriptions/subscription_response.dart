import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases_example/provider/linkfive_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionResponseStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveResponseData?>(
          stream: LinkFivePurchases.listenOnResponseData(),
          builder: (BuildContext context,
              AsyncSnapshot<LinkFiveResponseData?> snapshot) {
            if (snapshot.hasData) {
              var subscriptionData = snapshot.data;
              if (subscriptionData != null) {
                return Column(
                  children: [
                    Text("LinkFive Response"),
                    ...subscriptionData.subscriptionList.map((e) => Text(e.sku))
                  ],
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}

class SubscriptionResponseProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Consumer<LinkFiveProvider>(
          builder: (_, linkFiveProvider, __) {
            if (linkFiveProvider.linkFiveResponseData != null) {
              var subscriptionData = linkFiveProvider.linkFiveResponseData;
              if (subscriptionData != null) {
                return Column(
                  children: [
                    Text("LinkFive Response"),
                    ...subscriptionData.subscriptionList.map((e) => Text(e.sku))
                  ],
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}
