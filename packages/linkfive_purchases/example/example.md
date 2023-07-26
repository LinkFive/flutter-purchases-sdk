# Examples

## Provider Example

```dart
class LinkFiveProvider extends ChangeNotifier {
  LinkFiveProducts? products;
  LinkFiveActiveProducts? activeProducts;

  /// Streams that will be cleaned on dispose
  List<StreamSubscription> _streams = [];

  /// All verified Plans as List or emptyList
  List<LinkFivePlan> get activePlanList => activeProducts?.planList ?? [];

  /// LinkFive as CallbackInterface for your Paywall
  CallbackInterface get callbackInterface => LinkFivePurchases.callbackInterface;

  /// conveniently check if the user has any activeProducts
  bool get hasActiveProduct => activeProducts != null && activeProducts!.planList.isNotEmpty;

  /// Initialize LinkFive with your Api Key
  ///
  /// Please register on our website: https://www.linkfive.io to get an api key
  LinkFiveProvider(String apiKey, {LinkFiveLogLevel logLevel = LinkFiveLogLevel.DEBUG}) {
    LinkFivePurchases.init(apiKey, logLevel: logLevel);
    _streams.add(LinkFivePurchases.products.listen(_productsUpdate));
    _streams.add(LinkFivePurchases.activeProducts.listen(_activeProductsUpdate));
  }

  /// Saves available Products and notifies all listeners
  void _productsUpdate(LinkFiveProducts data) async {
    products = data;
    notifyListeners();
  }

  /// Saves active Products and notifies all listeners
  void _activeProductsUpdate(LinkFiveActiveProducts data) {
    activeProducts = data;
    notifyListeners();
  }

  Future<LinkFiveProducts?> fetchProducts() {
    return LinkFivePurchases.fetchProducts();
  }

  Future<bool> restoreSubscriptions() {
    return LinkFivePurchases.restore();
  }

  Future<bool> purchase(ProductDetails productDetail) async {
    return LinkFivePurchases.purchase(productDetail);
  }

  switchPlan(LinkFivePlan oldPurchasePlan, LinkFiveProductDetails productDetails, {ProrationMode? prorationMode}) {
    return LinkFivePurchases.switchPlan(oldPurchasePlan, productDetails, prorationMode: prorationMode);
  }

  @override
  void dispose() async {
    for (final element in _streams) {
      await element.cancel();
    }
    _streams = [];
    super.dispose();
  }
}

```

## Use the provider and show the UI
This example uses Navigation 2.0

```dart
import 'package:company_friends/provider/linkfive_provider.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchases_intl/helper/paywall_helper.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:in_app_purchases_intl/extensions/duration_extension.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:provider/provider.dart';

class PremiumPage extends Page {
  List<SubscriptionData>? _buildPaywallData(BuildContext context, LinkFiveProducts? products) {
    if (products == null) {
      return null;
    }
    final subList = <SubscriptionData>[];

    for (final product in products.productDetailList) {
      final pricingPhase = product.pricingPhases.first;
      final durationStrings = pricingPhase.billingPeriod.jsonValue.fromIso8601(PaywallL10NHelper.of(context));
      final data = SubscriptionData(
        durationTitle: durationStrings.durationTextNumber,
        durationShort: durationStrings.durationText,
        price: pricingPhase.formattedPrice,
        productDetails: product.productDetails,
      );
      subList.add(data);
    }

    return subList;
  }

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return Consumer<LinkFiveProvider>(
          builder: (_, provider, __) {
            return PaywallScaffold(
                child: SimplePaywall(
                  callbackInterface: LinkFivePurchases.callbackInterface,
                  subscriptionListData: _buildPaywallData(context, provider.products),
                  title: "Go Premium!",
                  subTitle: "All features at a glance:",
                  bulletPoints: [
                    IconAndText(
                      Icons.person_add,
                      "Invite your Coworkers",
                    ),
                    IconAndText(Icons.group, "Unlimited Coworkers"),
                    IconAndText(Icons.domain, "Unlimited Companies"),
                    IconAndText(Icons.support_agent, "Instant Support"),
                    IconAndText(Icons.tv, "No Ads")
                  ],
                  tosData: TextAndUrl("Terms of Service", "https://linkfive.io"),
                  ppData: TextAndUrl("Privacy Policy", "https://linkfive.io"),
                  successTitle: "Great",
                  // ...
                ));
          },
        );
      },
    );
  }
}
```