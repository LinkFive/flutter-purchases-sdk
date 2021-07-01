import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/key/keyLoader.dart';
import 'package:linkfive_purchases_example/subscriptions/SubscriptionPage.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  @override
  void initState() {
    initLinkFive();
    super.initState();
  }

  initLinkFive() async {
    var keys = await KeyLoader().load(context);
    // LinkFivePurchases.init(keys.linkFiveApiKey, fetchSubscription: true);
    await LinkFivePurchases.init(keys.linkFiveApiKey);
    LinkFivePurchases.fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkFive Subscription Test App'),
      ),
      body: SubscriptionPage(),
    );
  }
}
