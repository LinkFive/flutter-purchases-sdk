import 'package:example_local/subscriptions/product_offering.dart';
import 'package:example_local/subscriptions/subscription_active.dart';
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
              onPressed: () async {
                await LinkFivePurchases.reloadActivePlans();
              },
              child: const Text('Reload Active Plans')),
          ElevatedButton(
              onPressed: () async {
                await LinkFivePurchases.fetchProducts();
              },
              child: Text("Load Offering")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
            ElevatedButton(
                onPressed: () async {
                  await LinkFivePurchases.setUserId(null);
                },
                child: Text("Remove UserId")),
            ElevatedButton(
                onPressed: () async {
                  await LinkFivePurchases.setUserId("abc");
                },
                child: Text("Set User Id"))
          ]),
          ProductOfferingStream(),
          ProductActiveStream(),
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
