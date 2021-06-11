
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_active.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_offering.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: Column(
      children: [
        SubscriptionOffering(),
        SubscriptionActive()
      ],
    ),
    );
  }
  
}