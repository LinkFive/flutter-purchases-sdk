import 'dart:async';

import 'package:linkfive_purchases/linkfive_purchases.dart';

/// LinkFive Purchases.
///
/// Welcome to LinkFive!
///
/// The docs can be found here https://www.linkfive.io/docs/
class LinkFivePurchases {

  /// You should make no instance of this class
  LinkFivePurchases._();

  /// Plugin Version
  static const VERSION = "4.0.0";

  /// Initialize LinkFive with your Api Key
  ///
  /// Please register on our website: https://www.linkfive.io to get an api key
  ///
  /// Possible usage:
  ///
  /// await LinkFivePurchases.init(linkFiveApiKey)
  ///
  /// and then later while or before you show your paywall ui:
  ///
  /// await LinkFivePurchases.fetchProducts()
  ///
  /// It's not recommended to do:
  ///
  /// await LinkFivePurchases.init(linkFiveApiKey)
  /// await LinkFivePurchases.fetchProducts());
  ///
  /// [LinkFiveLogLevel] to see or hide internal logging
  static Future<LinkFiveActiveProducts> init(String apiKey, {LinkFiveLogLevel logLevel = LinkFiveLogLevel.WARN}) {
    return LinkFivePurchasesImpl().init(apiKey, logLevel: logLevel, env: LinkFiveEnvironment.PRODUCTION);
  }

  /// By Default, the plugin does not fetch any Products to offer.
  ///
  /// You have to call this method at least once. The best case would be to call
  /// fetchProducts whenever you want to show your offer to the user e.g. on the paywall page
  ///
  /// This method will call LinkFive to get all available products for the user
  /// and then uses the native platform to fetch the product information
  ///
  /// This method will return the Products but will also send the products to the [LinkFivePurchases.products] stream
  ///
  /// riverpod example:
  ///
  /// class PremiumOfferNotifier extends Notifier<LinkFiveProducts?> {
  ///   /// fetched once whenever the user enters the paywall
  ///   Future<void> fetchOffering() async {
  ///     state = LinkFivePurchases.fetchProducts();
  ///   }
  ///
  ///   void purchase(LinkFiveProductDetails productDetails) {
  ///     LinkFivePurchases.purchase(productDetails.productDetails);
  ///   }
  ///
  ///   void restore() {
  ///     LinkFivePurchases.restore();
  ///   }
  ///
  ///   @override
  ///   LinkFiveProducts? build() {
  ///     return null;
  ///   }
  /// }
  ///
  /// widget example:
  ///
  /// class _PurchasePaywall extends ConsumerWidget {
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     final premiumOffer = ref.watch(premiumOfferProvider);
  ///     if (premiumOffer == null) {
  ///       // return Page Loading Widget
  ///     }
  ///
  ///     return ListView(children: [
  ///         for (final offer in premiumOffer.productDetailList)
  ///           switch (offer.productType) {
  ///               LinkFiveProductType.OneTimePurchase => LayoutBuilder(builder: (_, _) {
  ///                 // build your One Time Purchase Widget
  ///                 // e.g:
  ///                 // Text(offer.oneTimePurchasePrice.formattedPrice)
  ///
  ///                 // and later when pressed:
  ///                 // onPressed: () {
  ///                 //   ref.read(premiumOfferProvider.notifier).purchase(offer);
  ///                 // }
  ///               }),
  ///               LinkFiveProductType.Subscription => LayoutBuilder(builder: (_, _) {
  ///                 // build your Subscription Purchase Widget
  ///                 // use the pricing Phases:
  ///                 // for (var pricingPhase in offer.pricingPhases) {
  ///                 //   Text(pricingPhase.formattedPrice);
  ///                 //   Text(pricingPhase.billingPeriod.iso8601); // e.g.: P6M
  ///                 // }
  ///
  ///                 // and later when pressed:
  ///                 // onPressed: () {
  ///                 //   ref.read(premiumOfferProvider.notifier).purchase(offer);
  ///                 // }
  ///               }),
  ///           }
  ///         ]
  ///     );
  ///   }
  /// }
  ///
  /// @return [LinkFiveProducts] or null if no subscriptions found
  static Future<LinkFiveProducts?> fetchProducts() {
    return LinkFivePurchasesImpl().fetchProducts();
  }

  /// This will restore the subscriptions a user previously purchased.
  ///
  /// All data will be refreshed and notified and delivered through the product stream
  static Future<bool> restore() {
    return LinkFivePurchasesImpl().restore();
  }

  /// USE WITH CARE. We're currently testing the new restore method
  ///
  /// All In App purchases are handled async, it's difficult to wait for something, that happens in a different thread.
  ///
  /// This will restore the products a user previously purchased.
  static Future<LinkFiveActiveProducts> restoreFuture() {
    return LinkFivePurchasesImpl().restoreWithFuture();
  }

  /// This will reload all active Plans for the current user
  ///
  /// This method will also be called on LinkFive INIT
  ///
  /// You usually just do on on App Start, but whenever you think they is a change,
  /// you can manually reload the active Plans for the current user
  ///
  static Future<LinkFiveActiveProducts> reloadActivePlans() {
    return LinkFivePurchasesImpl().reloadActivePlans();
  }

  /// This will trigger the purchase flow for the user.
  ///
  /// A verified purchase will be send to activeProducts Stream
  ///
  /// @return Future<bool>: if the "purchase screen" is visible.
  /// Please note: This is not a successful purchase.
  static Future<bool> purchase(ProductDetails productDetails) async {
    return LinkFivePurchasesImpl().purchase(productDetails);
  }

  /// USE WITH CARE. We're currently testing the new purchase method
  ///
  /// All In App purchases are handled async, it's difficult to wait for something, that happens in a different thread.
  ///
  /// This will trigger the purchase flow for the user and returns a LinkFiveActiveProducts object.
  static Future<LinkFiveActiveProducts> purchaseFuture(dynamic productDetails) {
    return LinkFivePurchasesImpl().purchaseFuture(productDetails);
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
  static Future<bool> switchPlan(LinkFivePlan oldPurchasePlan, LinkFiveProductDetails productDetails,
      {ProrationMode? prorationMode}) {
    return LinkFivePurchasesImpl().switchPlan(oldPurchasePlan, productDetails, prorationMode: prorationMode);
  }

  /// This Stream contains all available Products you can offer to your user.
  ///
  /// productDetailList is not NULL. If the value is null, you probably never
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
  static Stream<LinkFiveProducts> get products => LinkFivePurchasesImpl().products;

  /// If the user has an active verified purchase, the stream will contain all necessary information
  /// An active product is a verified active subscription the user purchased
  ///
  /// @return [LinkFiveActiveProducts] which can also be null. Please treat it as no active subscription.
  ///
  /// [LinkFiveActiveProducts.planList] is a List of [LinkFivePlan] verified plans
  ///
  static Stream<LinkFiveActiveProducts> get activeProducts => LinkFivePurchasesImpl().activeProducts;

  ///
  /// Set the UTM source of a user
  /// You can filter this value in your playout
  ///
  static setUTMSource(String? utmSource) {
    LinkFivePurchasesImpl().setUTMSource(utmSource);
  }

  ///
  /// Set your own environment. Example: Production, Staging
  ///
  /// You can filter this value in your subscription playout
  ///
  static setEnvironment(String? environment) {
    LinkFivePurchasesImpl().setEnvironment(environment);
  }

  ///
  /// Set your own user ID
  ///
  /// This will also link all subscriptions to the current user if exist
  ///
  /// You can also filter this value in your subscription Playout
  ///
  static Future<LinkFiveActiveProducts> setUserId(String? userId) {
    return LinkFivePurchasesImpl().setUserId(userId);
  }

  ///
  /// This is the callback Interface for the UI Paywall plugin
  ///
  /// You can just add the callbackInterface as the UI Paywall callback interface
  ///
  static LinkFivePurchasesImpl get callbackInterface => LinkFivePurchasesImpl();

  /// This Stream returns true => if the purchase is currently in Progress. This means you should show a loading
  /// indicator or block the purchase button while processing
  ///
  /// returns false => if there is no purchase in Progress.
  ///
  /// Example riverpod notifier:
  ///
  /// class PremiumPurchaseInProgressNotifier extends Notifier<bool> {
  ///   init() {
  ///     LinkFivePurchases.purchaseInProgressStream.listen((bool isPurchaseInProgress) {
  ///       state = isPurchaseInProgress;
  ///     });
  ///   }
  ///
  ///   @override
  ///   bool build() {
  ///     return false;
  ///   }
  /// }
  ///
  static Stream<bool> get purchaseInProgressStream => LinkFivePurchasesImpl().purchaseInProgressStream();
}
