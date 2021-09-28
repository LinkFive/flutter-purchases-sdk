import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_active.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_offering.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_response.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SubscriptionResponseStream(),
          SubscriptionResponseProvider(),
          SubscriptionOfferingStream(),
          SubscriptionOfferingProvider(),
          SubscriptionActiveStream(),
          SubscriptionActiveProvider(),
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
