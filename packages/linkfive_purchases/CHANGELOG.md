## 3.0.0
Breaking Change Update.

* Flutter ^3.10 Update
* Dart ^3.0.0 Update
* We now support Google Play Base-Plans
* We updated the in_app_purchase flutter lib to latest
* There is a new `Period` class that holds a `PeriodUnit` and `amount` of units.
* We added the `PricingPhase` to Google Play Store and Apple App Store
* We added a new Recurrence class that holds the subscription recurrence type 

### ProductDetails, Pricing Phase & Google‘s new Base Plans approach
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

#### Pricing Phase
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

#### Period & PeriodUnit class

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

##### From the Period class to a readable user-friendly text
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

## 2.1.3
* Update dependencies
* This will also fix the restore-bug on Android

## 2.1.2
* Make plugin compatible with pre Flutter 3.0

## 2.1.1
* Add Test API Key handling. Use "TmljZSAyIG1lZXQgeW91IE1yLkhhY2tlcg=" to quickly test this plugin but please do not use it more than just the initial testing.
* Added some more Unit tests.

## 2.1.0
* Update for Flutter ^3.0.0
* fetchProducts() now waits until the initialization is done. There is no need to await LinkFiveProducts.init(...) anymore.
* Update to in_app_purchase: 3.0.6
* We added more unit tests.


## 2.0.2
* We fixed a bug when setting the userID is not saved on the device.
* we also implemented all new dart analysis changes
* updated to flutter 2.10.4

## 2.0.1
* fixing PendingPurchase handler which tells the UI that the purchase is ongoing.
* We also now send the plugin version to LinkFive with each request
* update the Example project


## 2.0.0

Release of LinkFive 2.0

With this major release we are paving the way for flutter web subscriptions as well as other exciting features coming soon to LinkFive.

A subscription is now called a Plan to prepare for flutter web subscriptions and other recurring or time-framed plans like coupon plans, team plans, etc.

* `LinkFivePurchases.fetchSubscriptions();` is now `LinkFivePurchases.fetchProducts();`
* `LinkFiveSubscriptionData` is now `LinkFiveProducts` and they own a List of `LinkFiveProductDetails` for better understanding.
* `LinkFiveActiveSubscriptionData` is now `LinkFiveActiveProducts` and they own a List of `LinkFivePlan`.

A LinkFivePlan has a completely new body:

* String productId;
* String planId;
* String rootId;
* DateTime purchaseDate;
* DateTime endDate;
* String storeType;
* String? customerUserId;
* bool? isTrial;
* String? familyName;
* String? attributes;
* String? duration;

* Listen on purchase updates changes from `LinkFivePurchases.listenOnActiveSubscriptionData()` to `LinkFivePurchases.activeProducts` which is much simpler.

**Paywall UI Helper changes**

* `products.getSubscriptionData(context: context)`  is now `products.paywallUIHelperData(context: context)`

* LinkFivePurchases.init("API Key") now returns a Future<> which you should await before you fetch your products

## 1.5.0

Breaking change: fetchSubscriptions returns a Future<LinkFiveSubscriptionData?> instead of Future<List<ProductDetails>?>
> LinkFiveSubscriptionData has `List<LinkFiveProductDetails> linkFiveSkuData` which contains the productDetail.

* listenOnResponseData is now deprecated and won't be replaced.
* LinkFiveVerifiedReceipt now has subscriptionDuration which containts the duration of the subscription. P1W, P1M, P3M, P6M, P1Y
* Added some more documentation

## 1.4.0
Add Switch Plan functionality. You can now call LinkFivePurchases.switchPlan(...) to switch from one plan to another.
Add more documentation

## 1.3.0
update to interface 0.0.7
return a Future<List<ProductDetails>?> on fetchSubscriptions instead of a dynamics, thanks to king-louis-rds for the feedback!
added platform files again to satisfy pub.dev points (hopefully)

## 1.2.0
update to interface 0.0.6 
* It fetches the subscriptions on load call now
  update intl to 0.0.3
  removed the unused android folder
  Prepared the package for the new LinkFive provider package

## 1.1.1
remove unused dependencies

## 1.1.0
add easy paywall ui integration.
add provider example.
add streambuilder example.
add intl package.
add interface package

## 1.0.1
* fixed a bug where a purchase was not immediately processed as a purchase.  

## 1.0.0
* Initial and tested production release
