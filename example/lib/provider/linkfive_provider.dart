import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:linkfive_purchases/purchases.dart';
import 'package:linkfive_purchases_example/key/keyLoader.dart';

class LinkFiveProvider extends ChangeNotifier {
  LinkFivePurchasesMain linkFivePurchases = LinkFivePurchasesMain();

  LinkFiveResponseData? linkFiveResponseData = null;
  LinkFiveSubscriptionData? linkFiveSubscriptionData = null;
  LinkFiveActiveSubscriptionData? linkFiveActiveSubscriptionData = null;

  List<StreamSubscription> _streams = [];

  LinkFiveProvider(Keys keys) {
    linkFivePurchases.init(keys.linkFiveApiKey,
        env: LinkFiveEnvironment.STAGING);
    linkFivePurchases.fetchSubscriptions();
    _streams.add(
        linkFivePurchases.listenOnResponseData().listen(_responseDataUpdate));
    _streams.add(linkFivePurchases
        .listenOnSubscriptionData()
        .listen(_subscriptionDataUpdate));
    _streams.add(linkFivePurchases
        .listenOnActiveSubscriptionData()
        .listen(_activeSubscriptionDataUpdate));
  }

  void _responseDataUpdate(LinkFiveResponseData? data) {
    linkFiveResponseData = data;
    notifyListeners();
  }

  void _subscriptionDataUpdate(LinkFiveSubscriptionData? data) async {
    // await Future.delayed(Duration(seconds: 3));
    linkFiveSubscriptionData = data;
    notifyListeners();
  }

  void _activeSubscriptionDataUpdate(LinkFiveActiveSubscriptionData? data) {
    linkFiveActiveSubscriptionData = data;
    notifyListeners();
  }

  @override
  void dispose() {
    _streams.forEach((element) async {
      await element.cancel();
    });
    _streams = [];
    super.dispose();
  }
}
