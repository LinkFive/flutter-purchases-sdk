import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

class LinkFiveProvider extends ChangeNotifier {
  /// LinkFive client
  final LinkFivePurchasesMain linkFivePurchases = LinkFivePurchasesMain();

  /// LinkFive subscription holder that you can offer to your user
  LinkFiveSubscriptionData? availableSubscriptionData;

  /// All verified receipt received by LinkFive
  LinkFiveActiveSubscriptionData? activeSubscriptionData;

  /// Streams that will be cleaned on dispose
  List<StreamSubscription> _streams = [];

  /// All verified receipts as List or emptyList
  List<LinkFiveVerifiedReceipt> get verifiedReceiptList =>
      activeSubscriptionData?.subscriptionList ?? [];

  /// LinkFive as CallbackInterface for your Paywall
  CallbackInterface get callbackInterface => linkFivePurchases;

  /// Init LinkFive with your API Key
  /// [LinkFiveEnvironment] is 99,999..% [LinkFiveEnvironment.PRODUCTION] better not touch it
  LinkFiveProvider(String apiKey,
      {LinkFiveEnvironment environment = LinkFiveEnvironment.PRODUCTION}) {
    linkFivePurchases.init(apiKey, env: environment);
    _streams.add(linkFivePurchases
        .listenOnSubscriptionData()
        .listen(_subscriptionDataUpdate));
    _streams.add(linkFivePurchases
        .listenOnActiveSubscriptionData()
        .listen(_activeSubscriptionDataUpdate));
  }

  /// Saves available Subscriptions and notifies all listeners
  void _subscriptionDataUpdate(LinkFiveSubscriptionData? data) async {
    availableSubscriptionData = data;
    notifyListeners();
  }

  /// Saves active Subscriptions and notifies all listeners
  void _activeSubscriptionDataUpdate(LinkFiveActiveSubscriptionData? data) {
    activeSubscriptionData = data;
    notifyListeners();
  }

  /// Fetch all available Subscription for purchase for the user
  /// The provider will notify you for changes
  fetchSubscriptions() async {
    return LinkFivePurchases.fetchSubscriptions();
  }

  /// Restore Subscriptions of the user
  /// The provider will notify you for changes
  restoreSubscriptions() async {
    return LinkFivePurchases.restore();
  }

  /// make a purchase
  /// The provider will notify you for changes
  /// The future returns if the "purchase screen" is visible to the user
  /// and not if the purchase was successful
  purchase(ProductDetails productDetail) async {
    return LinkFivePurchases.purchase(productDetail);
  }

  @override
  void dispose() async {
    for (var element in _streams) {
      await element.cancel();
    }
    _streams = [];
    super.dispose();
  }

  /// helper function for the paywall to make it easier.
  /// returns the subscriptionDataList or if null, an empty list
  List<SubscriptionData> getSubscriptionListData(BuildContext context) =>
      availableSubscriptionData?.getSubscriptionData(context: context) ?? [];
}
