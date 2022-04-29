import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_active.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_offering.dart';

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
          SizedBox(height: 16),
          Text("LinkFive",
              style: Theme.of(context).textTheme.headline6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
          ]),
          Text("User",
              style: Theme.of(context).textTheme.headline6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                onPressed: () async {
                  await LinkFivePurchases.setUserId(null);
                },
                child: Text("Logout | Remove UserId")),
            ElevatedButton(
                onPressed: () async {
                  await LinkFivePurchases.setUserId("abc");
                },
                child: Text("Set User Id"))
          ]),
          SizedBox(height: 16),
          Text("Offering",
              style: Theme.of(context).textTheme.headline6),
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
