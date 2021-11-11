import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

/// LinkFive Provider
///
/// Initialize LinkFive with your Api Key
///
/// Please register on our website: https://www.linkfive.io to get an api key
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

  /// Initialize LinkFive with your Api Key
  ///
  /// Please register on our website: https://www.linkfive.io to get an api key
  ///
  /// [LinkFiveEnvironment] is 99,999..% [LinkFiveEnvironment.PRODUCTION] better not touch it
  LinkFiveProvider(String apiKey,
      {LinkFiveEnvironment environment = LinkFiveEnvironment.PRODUCTION}) {
    linkFivePurchases.init(apiKey, env: environment);
    _streams.add(linkFivePurchases.products.listen(_subscriptionDataUpdate));
    _streams.add(
        linkFivePurchases.activeProducts.listen(_activeSubscriptionDataUpdate));
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

  /// Handles the Switch Plan functionality.
  ///
  /// You can switch from one Subscription plan to another. Example: from currently a 1 month subscription to a 3 months subscription
  ///
  /// on iOS: you can only switch to a plan which is in the same Subscription Family
  /// [oldPurchaseDetails] given by the LinkFive Plugin
  /// [productDetails] from the purchases you want to switch to
  /// [prorationMode] Google Only: default replaces immediately the subscription, and the remaining time will be prorated and credited to the user.
  ///   Check https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.ProrationMode for more information
  switchPlan(
      LinkFiveVerifiedReceipt oldPurchaseDetails, ProductDetails productDetails,
      {ProrationMode? prorationMode}) {
    return LinkFivePurchases.switchPlan(oldPurchaseDetails, productDetails,
        prorationMode: prorationMode);
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
