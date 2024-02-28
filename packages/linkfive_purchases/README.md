# In-app purchases and subscription management for Flutter

This document provides a comprehensive overview of the LinkFive Purchases Flutter library, allowing you to integrate in-app purchases and subscription management functionalities into your Flutter application.

## What is LinkFive Purchases?
LinkFive Purchases empowers developers to seamlessly implement and manage in-app purchases and subscriptions within their Flutter applications. It simplifies the integration process, taking care of the complexities and streamlining the experience for both developers and users.

## Getting Started

1. Sign Up and Obtain API Key: Visit the LinkFive website (https://app.linkfive.io/sign-up) to register and acquire your unique API key (it's free!). This key is essential for initializing the LinkFive Purchases plugin within your application.
2. Installation: Add the `linkfive_purchases` package to your pubspec.yaml file and run `pub get` to download and install the necessary dependencies.

## Core Functionalities

* *Supported Purchase Types:*
* * Subscriptions: Offer recurring billing plans that provide users with ongoing access to premium features or content within your app.
* * One-Time Purchases: Enable users to purchase a product or service permanently with a single payment.

* *Initialization:*
* * Employ the `init` method to initialize the LinkFive Purchases plugin, providing your API key as an argument. You can optionally set the logging level using the `logLevel` parameter.

```dart
await LinkFivePurchases.init("API_KEY");
```

* *Fetching Products:*
* * Utilize the `fetchProducts` method to retrieve a list of available products from LinkFive. This method is crucial for populating your paywall or displaying relevant subscription options to users.

```dart
await LinkFivePurchases.fetchProducts();
```

* *Purchasing Products:*
* * Trigger the purchase flow for a specific product using the `purchase` method. This method takes a `ProductDetails` object as input, representing the product the user intends to purchase.

```dart
await LinkFivePurchases.purchase(productDetails);
```

* * BETA-function: In version 4.x we also added `purchaseFuture` which will wait for the purchase to finish and return the ActiveProducts. 

```dart
await LinkFivePurchases.purchaseFuture(productDetails);
```

* *Restoring Purchases:*
* * The `restore` method enables users to restore previously purchased products. This ensures continued access to subscribed features upon app reinstallation or device change.

```dart
await LinkFivePurchases.restore();
```

* * BETA-function: In version 4.x we also added `restoreFuture` which will wait for the restore to finish and return the ActiveProducts.

```dart
await LinkFivePurchases.restoreFuture();
```

* *Products Stream:*
* * The `products` stream continuously delivers information about the user's offering. Whenever the user opens the paywall, you want to show the data that is included in this stream.
```dart
stream = LinkFivePurchases.products.listen((products) {
  // Handle products here
});
```

* *Active Products Stream:*
* * The `activeProducts` stream continuously delivers information about the user's active and verified products. This stream proves valuable for managing access to subscription-based features or One-time purchases within your application.
```dart
stream = LinkFivePurchases.activeProducts.listen((activeProducts) {
  // Handle active products here
});
```

### Purchase in Progress Stream
The `purchaseInProgressStream` provides real-time updates on the purchase process. This stream is helpful for displaying loading indicators or disabling purchase buttons while a purchase is underway.

An example riverpod Notifier would be:

```dart
/// true -> show loading indicator / disable purchase button
/// false -> disable loading indicator / enable purchase Button  
class PremiumPurchaseInProgressNotifier extends Notifier<bool> {
  init() {
    ref.read(billingRepositoryProvider).purchaseInProgressStream().listen((bool isPurchaseInProgress) {
      state = isPurchaseInProgress;
    });
  }

  @override
  bool build() {
    return false;
  }
}
```

## Subscription and One-Time Purchase Offerings
A typical riverpod notifier implementation would be:

```dart
class PremiumOfferNotifier extends Notifier<LinkFiveProducts?> {
  /// fetched once whenever the user enters the paywall  
  Future<void> fetchOffering() async {
    state = await ref.read(billingRepositoryProvider).fetchOffering();
  }

  void purchase(LinkFiveProductDetails productDetails) {
    ref.read(billingRepositoryProvider).purchase(productDetails.productDetails);
  }

  void restore() {
    ref.read(billingRepositoryProvider).restore();
  }

  @override
  LinkFiveProducts? build() {
    return null;
  }
}
```

And the Widget Implementation:

```dart
class _PurchasePaywall extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumOffer = ref.watch(premiumOfferProvider);
    if (premiumOffer == null) {
      // return Page Loading Widget
    }
    
    return ListView(children: [
        for (final offer in premiumOffer.productDetailList)
          switch (offer.productType) {
              LinkFiveProductType.OneTimePurchase => LayoutBuilder(builder: (_, _) {
                // build your One Time Purchase Widget
                // e.g:
                // Text(offer.oneTimePurchasePrice.formattedPrice)
                
                // and later when pressed:
                // onPressed: () {
                //   ref.read(premiumOfferProvider.notifier).purchase(offer);
                // }
              }), 
              LinkFiveProductType.Subscription => LayoutBuilder(builder: (_, _) {
                // build your Subscription Purchase Widget
                // use the pricing Phases:
                // for (var pricingPhase in offer.pricingPhases) {
                //   Text(pricingPhase.formattedPrice);
                //   Text(pricingPhase.billingPeriod.iso8601); // e.g.: P6M
                // }

                // and later when pressed:
                // onPressed: () {
                //   ref.read(premiumOfferProvider.notifier).purchase(offer);
                // }
              }), 
          }
        ]
    );
  }
}
```

## Active & Purchased Products
A typical riverpod notifier implementation would look like this:

```dart
class PremiumPurchaseNotifier extends Notifier<LinkFiveActiveProducts?> {
  Future<void> initBilling() async {
    // initialize LinkFive and wait for the active Products
    state = await ref.read(billingRepositoryProvider).load();
    
    // listen to all purchases and update the state
    ref.read(billingRepositoryProvider).purchaseStream().listen((LinkFiveActiveProducts activeProducts) {
      state = activeProducts;
    });
  }

  @override
  LinkFiveActiveProducts? build() {
    return null;
  }
}
```

LinkFiveActiveProducts holds all active purchases, Subscriptions and One-Time Purchases.

```dart
// LinkFiveActiveProducts
activeProducts.planList;
activeProducts.oneTimePurchaseList;
```

## Wrap LinkFive into a repository for testing

You can wrap the Purchases implementation inside a Repository pattern or use it directly.

```dart

final billingRepositoryProvider = Provider<BillingRepository>((ref) => LinkFiveBillingRepository());

class LinkFiveBillingRepository extends BillingRepository {
  @override
  Future<LinkFiveActiveProducts> load() async {
    return LinkFivePurchases.init(
      LinkFiveKey().apiKey,
      logLevel: LinkFiveLogLevel.DEBUG,
    );
  }

  @override
  Future<LinkFiveProducts?> fetchOffering() {
    return LinkFivePurchases.fetchProducts();
  }

  @override
  Future<LinkFiveActiveProducts> loadActiveProducts() async {
    return LinkFivePurchases.reloadActivePlans();
  }

  @override
  void purchase(ProductDetails productDetails) async {
    await LinkFivePurchases.purchase(productDetails);
  }

  @override
  Future<void> restore() async {
    await LinkFivePurchases.restore();
  }

  Stream<LinkFiveActiveProducts> listenToPurchases() {
    return LinkFivePurchases.activeProducts;
  }

  @override
  Stream<LinkFiveActiveProducts> purchaseStream() {
    return LinkFivePurchases.activeProducts;
  }

  @override
  Stream<bool> purchaseInProgressStream() {
    return LinkFivePurchases.purchaseInProgressStream;
  }
}
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

That‘s it. Now the page will automatically offer the subscriptions to the user or if the user already bought the subscription, the paywall will show the success page.
