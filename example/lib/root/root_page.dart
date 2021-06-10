import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    initLinkFive();
  }

  initLinkFive() async {
    LinkFivePurchases.init(
        apiKey: "f790f42eb98bf27e41df0faa9120dd0238c32f7316d2a728e05242388d357612", fetchSubscription: true);
    var linkFiveSubscription = LinkFivePurchases.linkFiveResponse();
    linkFiveSubscription.listen((event) {
      print("App got event $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkFive Subscription Test App'),
      ),
      body: Center(
        child: Text('Running'),
      ),
    );
  }
}
