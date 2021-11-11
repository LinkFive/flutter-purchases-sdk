# The Easiest Implementation of Subscriptions for Flutter

Add the plugin to your Flutter app:

```
 $ flutter pub add linkfive_purchases
```

## Getting Started

Initialize the SDK. [Read our more detailed docs](https://www.linkfive.io/docs/flutter/initializing/)

```dart
LinkFivePurchases.init("LinkFive Api Key");
```

Get your API key after [Sign up](https://app.linkfive.io/sign-up?utm_source=flutter). It's free!

Fetch all available subscriptions from LinkFive. The result will be passed to the stream or returned as a Future. [Fetch Docs](https://www.linkfive.io/docs/flutter/show-subscription-offer/)

```dart
LinkFivePurchases.fetchSubscriptions();
```

### Subscription Streams

LinkFive mainly uses streams to pass data to your application. [Active Subscriptions Docs](https://www.linkfive.io/docs/flutter/get-all-active-subscriptions/)

```dart
// Stream of subscriptions to offer to the user
LinkFivePurchases.products

// Stream of active subscriptions
LinkFivePurchases.activeProducts
```

### Purchase a Subscription

Simply call purchase with the productDetails from the retrieved subscriptions. [Purchase Docs](https://www.linkfive.io/docs/flutter/make-a-purchase/)

```dart
await LinkFivePurchases.purchase( productDetails );
```

### Restore a Purchases

All restored subscriptions will be available through the activeSubscription listener. [Restore Docs](https://www.linkfive.io/docs/flutter/restore-a-purchase/)

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

## Provider usage
We offer a Provider Plugin which you can implement and use out of the box or you can create your own provider.

### LinkFive Provider Package
Check out [linkfive_purchases_provider](https://pub.dev/packages/linkfive_purchases_provider)

You just have to register the Provider with our API key and you're all set to use it
```dart
MultiProvider(
  providers: [
    // ...
    ChangeNotifierProvider(
      create: (context) => LinkFiveProvider("API_KEY"),
      lazy: false,
    ),
  ]
)
```

### Provider example

```dart
class LinkFiveProvider extends ChangeNotifier {
  LinkFivePurchasesMain linkFivePurchases = LinkFivePurchasesMain();

  LinkFiveSubscriptionData? linkFiveSubscriptionData = null;
  LinkFiveActiveSubscriptionData? linkFiveActiveSubscriptionData = null;

  List<StreamSubscription> _streams = [];

  LinkFiveProvider(Keys keys) {
    linkFivePurchases.init(keys.linkFiveApiKey, env: LinkFiveEnvironment.STAGING);
    linkFivePurchases.fetchSubscriptions();
    _streams.add(linkFivePurchases.products.listen(_subscriptionDataUpdate));
    _streams.add(linkFivePurchases.activeProducts.listen(_activeSubscriptionDataUpdate));
  }

  void _subscriptionDataUpdate(LinkFiveSubscriptionData? data) async {
    linkFiveSubscriptionData = data;
    notifyListeners();
  }

  void _activeSubscriptionDataUpdate(LinkFiveActiveSubscriptionData? data) {
    linkFiveActiveSubscriptionData = data;
    notifyListeners();
  }

  @override
  void dispose() {
    _streams.forEach((element) async { await element.cancel(); });
    _streams = [];
    super.dispose();
  }
}
```

## StreamBuilder usage

Show purchasable subscriptions

```dart
StreamBuilder<LinkFiveSubscriptionData?>(
  stream: LinkFivePurchases.products,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      var subscriptionData = snapshot.data;
      if(subscriptionData != null) {
        // subscriptionData to offer
      }
    }
    return Center(child: Text('Loading...'));
  },
```

Get Active Subscriptions

```dart
StreamBuilder<LinkFiveActiveSubscriptionData?>(
  stream: LinkFivePurchases.activeProducts,
  builder: (BuildContext context, snapshot) {
    if (snapshot.hasData) {
      var subscriptionData = snapshot.data;
      if (subscriptionData != null) {
        // Active subscriptionData
      }
    }
    return Center(child: Text('Loading...'));
  },
)
```

## Easy Integration with the Paywall UI package

Integrate linkfive_purchases with package [in_app_purchases_paywall_ui](https://pub.dev/packages/in_app_purchases_paywall_ui).

* it's working with just passing the linkFive client to the UI library
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
// get LinkFivePurchases object from your provider or just create it
final linkFivePurchases = LinkFivePurchasesMain();

// get subscription data from your provider or from your stream (as described above)
LinkFiveSubscriptionData? linkFiveSubscriptionData = subscriptionData;

// you can use your own strings or use the intl package to automatically generate the subscription strings
final subscriptionListData = linkFiveSubscriptionData?.getSubscriptionData(context: context) ?? []

SimplePaywall(
    // ...
    callbackInterface: linkFivePurchases,
    subscriptionListData: subscriptionListData,
    // ...
);
```

That‘s it. Now the page will automatically offer the subscriptions to the user or if the user already bought the subscription, the paywall will show the success page.
