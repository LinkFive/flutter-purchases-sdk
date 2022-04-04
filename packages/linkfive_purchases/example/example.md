# Examples

## Provider Example

Now also as a standalone package: [linkfive_purchases_provider](https://pub.dev/packages/linkfive_purchases_provider)

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

/// LinkFive Provider
///
/// Initialize LinkFive with your Api Key
///
/// Please register on our website: https://www.linkfive.io to get an api key
class LinkFiveProvider extends ChangeNotifier {
  /// LinkFive client as factory
  final LinkFivePurchasesMain linkFivePurchases = LinkFivePurchasesMain();

  /// LinkFive subscriptions that you can offer to your user
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
  /// [LinkFiveEnvironment] is 99,999..% [LinkFiveEnvironment.PRODUCTION] better not touch it
  LinkFiveProvider(String apiKey,
      {LinkFiveEnvironment environment = LinkFiveEnvironment.PRODUCTION}) {
    linkFivePurchases.init(apiKey, env: environment);
    _streams.add(linkFivePurchases.products.listen(_productsUpdate));
    _streams.add(
        linkFivePurchases.activeProducts.listen(_activeProductsUpdate));
  }

  /// Saves available Subscriptions and notifies all listeners
  void _productsUpdate(LinkFiveProducts data) {
    products = data;
    notifyListeners();
  }

  /// Saves active Subscriptions and notifies all listeners
  void _activeProductsUpdate(LinkFiveActiveProducts data) {
    activeProducts = data;
    notifyListeners();
  }

  /// Fetch all available Subscription for purchase for the user
  ///
  /// The provider will notify you for changes
  Future<LinkFiveProducts?> fetchProducts() {
    return LinkFivePurchases.fetchProducts();
  }

  /// Restore Subscriptions of the user
  ///
  /// The provider will notify you if there is a change
  restoreSubscriptions() {
    return LinkFivePurchases.restore();
  }

  /// Make a Purchase
  ///
  /// The provider will notify you if there is a change
  /// The future returns if the "purchase screen" is visible to the user
  /// and not if the purchase was successful
  Future<bool> purchase(ProductDetails productDetail) async {
    return LinkFivePurchases.purchase(productDetail);
  }

  /// Handles the Switch Plan functionality.
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
  switchPlan(LinkFivePlan oldPurchasePlan, LinkFiveProductDetails productDetails,
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

  /// helper function for the paywall to make it easier.
  ///
  /// returns the subscriptionDataList or if null, an empty list
  List<SubscriptionData> paywallUIHelperData(BuildContext context) =>
      products?.paywallUIHelperData(context: context) ?? [];
}

```

## Use the provider and show the UI
This example uses Navigation 2.0

```dart
import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';
import 'package:provider/provider.dart';

class ProviderSimplePaywall extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<LinkFiveProvider>(builder: (_, linkFiveProvider, __) {
      return PaywallScaffold(
          appBarTitle: "LinkFive Premium",
          child: SimplePaywall(
              theme: Theme.of(context),
              callbackInterface: linkFiveProvider.callbackInterface,
              subscriptionListData:
              linkFiveProvider.paywallUIHelperData(context),
              title: "Go Premium",
              // SubTitle
              subTitle: "All features at a glance",
              // Add as many bullet points as you like
              bulletPoints: [
                IconAndText(Icons.stop_screen_share_outlined, "No Ads"),
                IconAndText(Icons.hd, "Premium HD"),
                IconAndText(Icons.sort, "Access to All Premium Articles")
              ],
              // Shown if isPurchaseSuccess == true
              successTitle: "You're a Premium User!",
              // Shown if isPurchaseSuccess == true
              successSubTitle: "Thanks for your Support!",
              // Widget can be anything. Shown if isPurchaseSuccess == true
              successWidget: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text("Let's go!"),
                          onPressed: () {
                            print("let‘s go to the home widget again");
                          },
                        )
                      ])),
              tosData: TextAndUrl(
                  "Terms of Service", "https://www.linkfive.io/tos"),
              // provide your PP
              ppData: TextAndUrl(
                  "Privacy Policy", "https://www.linkfive.io/privacy"),
              // add a custom campaign widget
              campaignWidget: CampaignBanner(
                theme: Theme.of(context),
                headline: "🥳 Summer Special Sale",
              )));
    });
  }
}

```