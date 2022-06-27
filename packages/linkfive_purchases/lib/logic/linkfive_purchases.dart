import 'dart:async';

import 'package:linkfive_purchases/linkfive_purchases.dart';

/// LinkFive Purchases.
///
/// Welcome to LinkFive!
///
/// The docs can be found here https://www.linkfive.io/docs/
class LinkFivePurchases {
  /// Plugin Version
  static const VERSION = "2.1.0";

  /// Initialize LinkFive with your Api Key
  ///
  /// Please register on our website: https://www.linkfive.io to get an api key
  ///
  /// Possible usage:
  ///
  /// LinkFivePurchases.init(linkFiveApiKey)
  ///
  /// and then later while or before you show your paywall ui:
  ///
  /// LinkFivePurchases.fetchProducts()
  ///
  /// Also Possible but not recommended:
  ///
  /// LinkFivePurchases.init(linkFiveApiKey)
  /// LinkFivePurchases.fetchProducts());
  ///
  /// [LinkFiveLogLevel] to see or hide internal logging
  static Future<LinkFiveActiveProducts> init(
    String apiKey, {
    LinkFiveLogLevel logLevel = LinkFiveLogLevel.WARN
  }) {
    return LinkFivePurchasesMain().init(apiKey, logLevel: logLevel, env: LinkFiveEnvironment.PRODUCTION);
  }

  /// By Default, the plugin does not fetch any Products to offer.
  ///
  /// You have to call this method at least once. The best case would be to call
  /// fetchProducts whenever you want to show your offer
  ///
  /// Whenever you want to offer subscriptions to your users.
  ///
  /// This method will call LinkFive to get all available subscriptions for the user
  /// and then uses the native methods for either ios or android to fetch the subscription
  /// details like duration, price, name, id etc.
  ///
  /// All Data will be send to the stream
  ///
  /// @return [LinkFiveProducts] or null if no subscriptions found
  static Future<LinkFiveProducts?> fetchProducts() {
    return LinkFivePurchasesMain().fetchProducts();
  }

  /// This will restore the subscriptions a user previously purchased.
  ///
  /// All data will be refreshed and notified and delivered through the product stream
  static Future<bool> restore() {
    return LinkFivePurchasesMain().restore();
  }

  /// This will reload all active Plans for the current user
  ///
  /// This method will also be called on LinkFive INIT
  ///
  /// You usually just do on on App Start, but whenever you think they is a change,
  /// you can manually reload the active Plans for the current user
  ///
  static Future<LinkFiveActiveProducts> reloadActivePlans() {
    return LinkFivePurchasesMain().reloadActivePlans();
  }

  /// This will trigger the purchase flow for the user.
  ///
  /// A verified purchase will be send to activeProducts Stream
  ///
  /// @return Future<bool>: if the "purchase screen" is visible.
  /// Please note: This is not a successful purchase.
  static Future<bool> purchase(ProductDetails productDetails) async {
    return LinkFivePurchasesMain().purchase(productDetails);
  }

  /// Handles the Switch Plan functionality.
  ///
  /// You can switch from one Subscription plan to another. Example: from currently a 1 month subscription to a 3 months subscription
  /// on iOS: you can only switch to a plan which is in the same Subscription Family
  ///
  /// [oldPurchaseDetails] given by the LinkFive Plugin
  ///
  /// [productDetails] from the purchases you want to switch to
  ///
  /// [prorationMode] Google Only: default replaces immediately the subscription, and the remaining time will be prorated and credited to the user.
  ///   Check https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.ProrationMode for more information
  static Future<bool> switchPlan(
      LinkFivePlan oldPurchasePlan, LinkFiveProductDetails productDetails,
      {ProrationMode? prorationMode}) {
    return LinkFivePurchasesMain().switchPlan(oldPurchasePlan, productDetails,
        prorationMode: prorationMode);
  }

  /// This Stream contains all available Products you can offer to your user.
  ///
  /// productDetailList is NEVER NULL. If the value is null, you probably never
  /// called [LinkFivePurchases.fetchProducts]
  ///
  /// [LinkFiveProducts.productDetailList] is a List and contains all Subscriptions
  ///
  /// ProductDetails({
  ///     id,
  ///     title,
  ///     description,
  ///     price,
  ///     rawPrice,
  ///     currencyCode,
  ///     currencySymbol = ''
  ///     });
  static Stream<LinkFiveProducts> get products =>
      LinkFivePurchasesMain().products;

  /// If the user has an active verified purchase, the stream will contain all necessary information
  /// An active product is a verified active subscription the user purchased
  ///
  /// @return [LinkFiveActiveProducts] which can also be null. Please treat it as no active subscription.
  ///
  /// [LinkFiveActiveProducts.planList] is a List of [LinkFivePlan] verified plans
  ///
  static Stream<LinkFiveActiveProducts> get activeProducts =>
      LinkFivePurchasesMain().activeProducts;

  ///
  /// Set the UTM source of a user
  /// You can filter this value in your playout
  ///
  static setUTMSource(String? utmSource) {
    LinkFivePurchasesMain().setUTMSource(utmSource);
  }

  ///
  /// Set your own environment. Example: Production, Staging
  ///
  /// You can filter this value in your subscription playout
  ///
  static setEnvironment(String? environment) {
    LinkFivePurchasesMain().setEnvironment(environment);
  }

  ///
  /// Set your own user ID
  ///
  /// This will also link all subscriptions to the current user if exist
  ///
  /// You can also filter this value in your subscription Playout
  ///
  static Future<LinkFiveActiveProducts> setUserId(String? userId) {
    return LinkFivePurchasesMain().setUserId(userId);
  }

  ///
  /// This is the callback Interface for the UI Paywall plugin
  ///
  /// You can just add the callbackInterface as the UI Paywall callback interface
  ///
  static LinkFivePurchasesMain get callbackInterface => LinkFivePurchasesMain();
}
