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
        "f790f42eb98bf27e41df0faa9120dd0238c32f7316d2a728e05242388d357612", fetchSubscription: true);
    print("do the listen thing");
    var linkFiveResponse = LinkFivePurchases.linkFiveResponse();
    linkFiveResponse.listen((event) {
      print("App got event $event");
    });
    var linkFiveSubscription = LinkFivePurchases.linkFiveSubscription();
    linkFiveSubscription.listen((event) {
      print("App got subscription $event");
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
