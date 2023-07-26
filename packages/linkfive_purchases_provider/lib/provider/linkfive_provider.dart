import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

///
/// LinkFive Provider
///
/// Initialize LinkFive with your Api Key
///
/// Please register on our website: https://www.linkfive.io to get an api key
///
class LinkFiveProvider extends ChangeNotifier {
  /// LinkFive client as factory
  final LinkFivePurchasesImpl linkFivePurchases = LinkFivePurchasesImpl();

  ///
  /// LinkFive subscriptions that you can offer to your user
  ///
  /// To receive data on products, you have to call fetchProducts() first.
  ///
  LinkFiveProducts? products;

  /// All verified receipt received by LinkFive
  LinkFiveActiveProducts? activeProducts;

  /// Streams that will be cleaned on dispose
  List<StreamSubscription> _streams = [];

  /// All verified receipts as List or emptyList
  List<LinkFivePlan> get activePlanList => activeProducts?.planList ?? [];

  /// LinkFive as CallbackInterface for your Paywall
  CallbackInterface get callbackInterface => linkFivePurchases;

  /// conveniently check if the user has any activeProducts
  bool get hasActiveProduct =>
      activeProducts != null && activeProducts!.planList.isNotEmpty;

  /// Initialize LinkFive with your Api Key
  ///
  /// Please register on our website: https://www.linkfive.io to get an api key
  ///
  LinkFiveProvider(String apiKey,
      {LinkFiveLogLevel logLevel = LinkFiveLogLevel.WARN}) {
    linkFivePurchases.init(apiKey, logLevel: logLevel);
    _streams.add(linkFivePurchases.products.listen(_productsUpdate));
    _streams
        .add(linkFivePurchases.activeProducts.listen(_activeProductsUpdate));
  }

  ///
  /// Saves available Subscriptions and notifies all listeners
  ///
  void _productsUpdate(LinkFiveProducts data) async {
    products = data;
    notifyListeners();
  }

  ///
  /// Saves active Subscriptions and notifies all listeners
  ///
  void _activeProductsUpdate(LinkFiveActiveProducts data) {
    activeProducts = data;
    notifyListeners();
  }

  ///
  /// Fetch all available Subscription for purchase for the user
  ///
  /// The provider will notify you for changes
  ///
  Future<LinkFiveProducts?> fetchProducts() {
    return LinkFivePurchases.fetchProducts();
  }

  ///
  /// Restore Subscriptions of the user
  ///
  /// The provider will notify you if there is a change
  ///
  restoreSubscriptions() {
    return LinkFivePurchases.restore();
  }

  ///
  /// Make a Purchase
  ///
  /// The provider will notify you if there is a change
  /// The future returns if the "purchase screen" is visible to the user
  /// and not if the purchase was successful
  ///
  Future<bool> purchase(ProductDetails productDetail) async {
    return LinkFivePurchases.purchase(productDetail);
  }

  /// H
  /// andles the Switch Plan functionality.
  ///
  /// You can switch from one Subscription plan to another. Example: from currently a 1 month subscription to a 3 months subscription
  ///
  /// on iOS: you can only switch to a plan which is in the same Subscription Family
  ///
  /// [oldPurchasePlan] given by the LinkFive Plugin
  ///
  /// [productDetails] from the purchases you want to switch to
  ///
  /// [prorationMode] Google Only: default replaces immediately the subscription, and the remaining time will be prorated and credited to the user.
  ///   Check https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.ProrationMode for more information
  switchPlan(
      LinkFivePlan oldPurchasePlan, LinkFiveProductDetails productDetails,
      {ProrationMode? prorationMode}) {
    return LinkFivePurchases.switchPlan(oldPurchasePlan, productDetails,
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
}
