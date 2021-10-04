import 'package:flutter/material.dart';
import 'package:linkfive_purchases_example/subscriptions/subscription_page.dart';

class RawPage extends Page {
  RawPage() : super(key: ValueKey("RawPage"));

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return RawWidget();
        },
      );
}

class RawWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RawWidgetState();
}

class _RawWidgetState extends State<RawWidget> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkFive Subscription Test App'),
      ),
      body: SubscriptionPage(),
    );
  }
}
