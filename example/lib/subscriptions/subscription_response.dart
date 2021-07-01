import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';

class SubscriptionResponse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SubscriptionResponseState();
}

class _SubscriptionResponseState extends State<SubscriptionResponse> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<LinkFiveResponseData?>(
          stream: LinkFivePurchases.listenOnResponseData(),
          builder: (BuildContext context, AsyncSnapshot<LinkFiveResponseData?> snapshot) {
            if (snapshot.hasData) {
              var subscriptionData = snapshot.data;
              if (subscriptionData != null) {
                return Column(
                  children: [Text("LinkFive Response"), ...subscriptionData.subscriptionList.map((e) => Text(e.sku))],
                );
              }
            }
            return Center(child: Text('Loading...'));
          },
        ));
  }
}
