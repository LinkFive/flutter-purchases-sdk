import 'package:example_local/subscriptions/subscription_active.dart';
import 'package:example_local/subscriptions/subscription_offering.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class SubscriptionPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                LinkFivePurchases.fetchSubscriptions();
              },
              child: Text("Fetch")),
          SubscriptionOfferingStream(),
          SubscriptionActiveStream(),
          ElevatedButton(
              onPressed: () async {
                await LinkFivePurchases.restore();
              },
              child: const Text('restore'))
        ],
      ),
    );
  }
}
