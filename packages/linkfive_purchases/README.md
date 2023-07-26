# The Easiest Implementation of Subscriptions for Flutter

Add the plugin to your Flutter app:

```
 $ flutter pub add linkfive_purchases
```

## Getting Started

Initialize the SDK. [Read our more detailed docs](https://www.linkfive.io/docs/flutter/initializing/)

```dart
await LinkFivePurchases.init("LinkFive Api Key");
```

Get your API key after [Sign up](https://app.linkfive.io/sign-up?utm_source=flutter). It's free!

Fetch all available subscriptions from LinkFive. The result will be passed to the stream or returned as a Future. [Fetch Docs](https://www.linkfive.io/docs/flutter/show-subscription-offer/)

```dart
LinkFivePurchases.fetchProducts();

// or also

LinkFiveProducts? products = await LinkFivePurchases.fetchProducts(); 
```

### Product Streams

LinkFive mainly uses streams to send data to your application. [Active Subscriptions Docs](https://www.linkfive.io/docs/flutter/get-all-active-subscriptions/)

```dart
// Stream of Products to offer to the user
LinkFivePurchases.products

// Stream of purchased/active Products
LinkFivePurchases.activeProducts

// to get all offerings, do the following:
LinkFivePurchases.products.listen((LinkFiveProducts products) {
  print(products);
});

// or for all active Products, listen on .activeProducts
LinkFivePurchases.activeProducts.listen((LinkFiveActiveProducts activeProducts) {
  print(activeProducts);
});
```

### Purchase a Subscription
Simply call purchase and an object of ProductDetails which you got from the products stream. [Purchase Docs](https://www.linkfive.io/docs/flutter/make-a-purchase/)

```dart
await LinkFivePurchases.purchase( productDetails );
```

### Restore a Purchases
All restored subscriptions will be available through activeProducts. [Restore Docs](https://www.linkfive.io/docs/flutter/restore-a-purchase/)

```dart
LinkFivePurchases.restore();
```

### Switch from one subscription plan to another
You can switch from one Subscription plan to another. Example: from currently a 1 month subscription to a 3 months subscription. 

* On iOS: you can only switch to a plan which is in the same Subscription Family

The Proration Mode is Google Only. On default, it replaces immediately the subscription and the remaining time will be prorated and credited to the user. You can specify a different proration mode.

```dart
LinkFivePurchases.switchPlan(
  oldPurchaseDetails, 
  linkFiveProductDetails.productDetails,
  prorationMode: ProrationMode.immediateWithTimeProration
);
```

## ProductDetails, Pricing Phase & Google‘s new Base Plans approach
Google changed how they handle subscriptions and added Base Plans & PricingPhases to it's new data model. Unfortunately, the in_app_purchase library exposes different models depending on the platform.

We decided to combine the ProductDetails class into a simple to use class called `LinkFiveProductDetails` which holds `pricingPhases` for both platforms, Android & iOS.

```dart
class LinkFiveProductDetails {

  /// Platform dependent Product Details such as GooglePlayProductDetails or AppStoreProductDetails
  final ProductDetails productDetails;

  /// Base64 encoded attributes which you can define on LinkFive
  final String? attributes;

  /// Converts the new Google Play & AppStore Model to a known list of pricing phases
  List<PricingPhase> get pricingPhases;
}
```

### Pricing Phase
The PricingPhase class now holds all information about the product and it's phases. An example would be a FreeTrial phase and a yearly subscription as 2 elements in the PricingPhase list.

Here are all interesting parts of the class:

```dart
class PricingPhase {
  
  /// Represents a pricing phase, describing how a user pays at a point in time.
  int get billingCycleCount;

  /// Billing period for which the given price applies, specified in ISO 8601 format.
  Period get billingPeriod;

  /// Returns formatted price for the payment cycle, including its currency sign.
  String get formattedPrice;

  /// Returns the price for the payment cycle in micro-units, where 1,000,000
  /// micro-units equal one unit of the currency.
  int get priceAmountMicros;

  /// ISO 4217 e.g. EUR, USD
  String get priceCurrencyCode;

  /// Recurrence of the phase
  Recurrence get recurrence;
}
```

### Period & PeriodUnit class

The Period class now holds the length of a subscription.

```dart
class Period {
  final int amount;
  final PeriodUnit periodUnit;
}

enum PeriodUnit {
  DAYS('D'),
  WEEKS('W'),
  MONTH('M'),
  YEARS('Y');
}
```

A Period of 3 months would be Period(amount: 3, periodUnit: MONTH) and a year would be Period(amount: 1, periodUnit: YEAR),

#### From the Period class to a readable user-friendly text
We added a [intl-localization-package](https://pub.dev/packages/in_app_purchases_intl) which uses the `intl` package that can help you translate the Period into a readable text.

Here is the package on [pub.dev](https://pub.dev/packages/in_app_purchases_intl)

You can use the isoCode from the billingPeriod to get a readable String:
```dart
final translationClass = pricingPhase.billingPeriod.iso8601.fromIso8601(PaywallL10NHelper.of(context));
```

The translation class will output: 

* `7 days` from `P7D`
* `1 month` from `P1M` 
* `3 months` from `P3M` (or also `quarterly`)
* `1 year` from `P1Y` (or also `yearly`)

You can submit your own translation to it's github Repository.

### Provider example
Here is an example of a Provider Plugin which you can implement as a ChangeNotifier

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

## Easy Integration with the Paywall UI package

Integrate linkfive_purchases with package [in_app_purchases_paywall_ui](https://pub.dev/packages/in_app_purchases_paywall_ui).

* it's working with just passing the LinkFive client to the UI library
* Automatic purchase state management
* The UI is fully customizable
* You can control the UI on our [Website](https://www.linkfive.io)

### Purchase Page

<img src="https://raw.githubusercontent.com/LinkFive/flutter-purchases-sdk/master/resources/simple_paywall_design.png" alt="Simple Paywall"/>

### Success Page

<img src="https://raw.githubusercontent.com/LinkFive/flutter-purchases-sdk/master/resources/simple_paywall_design_success.png" alt="Simple Success page Paywall"/>

### Page State Management

<img src="https://raw.githubusercontent.com/LinkFive/flutter-purchases-sdk/master/resources/state_management_control.gif" alt="Simple Paywall Success state"/>

### Example usage with Paywall UI
usage with [in_app_purchases_paywall_ui](https://pub.dev/packages/in_app_purchases_paywall_ui).

```dart

// get subscription data from your provider or from your stream (as described above)
LinkFiveProducts? products = // your products you got through the products Stream

SimplePaywall(
  // ...
  // basically just the linkFivePurchases class
  callbackInterface: LinkFivePurchases.callbackInterface,

  // you can use your own strings or use the intl package to automatically generate the subscription strings
  subscriptionListData: _buildPaywallData(context, provider.products),
  // ...
);

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
```

That‘s it. Now the page will automatically offer the subscriptions to the user or if the user already bought the subscription, the paywall will show the success page.
