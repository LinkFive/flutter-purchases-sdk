# LinkFive Purchases flutter sdk

Flutter package available on pub.dev: [linkfive_purchases](https://pub.dev/packages/linkfive_purchases)

Add the SDK to your flutter app:

```
 $ flutter pub add linkfive_purchases
```

## Getting Started

Initialize the SDK

```
LinkFivePurchases.init("LinkFive Api Key");
```

Fetch all available subscriptions from LinkFive. The result will be passed to the Stream

```
LinkFivePurchases.fetchSubscriptions();
```

### Subscription Streams

LinkFive mainly uses streams to pass data to your application.

```
// Stream of subscriptions to offer to the user
LinkFivePurchases.listenOnSubscriptionData()

// Stream of active subscriptions
LinkFivePurchases.listenOnActiveSubscriptionData()
```

### Purchase a Subscription

Just call purchase including the productDetails from the subscription stream

```
await LinkFivePurchases.purchase( productDetails );
}
```

### Restore a Purchases

All restored subscriptions will be available through the activeSubscription listener

```
LinkFivePurchases.restore();
```

## StreamBuilder usage

Show purchasable subscriptions

```
StreamBuilder<LinkFiveSubscriptionData?>(
  stream: LinkFivePurchases.listenOnSubscriptionData(),
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

```
StreamBuilder<LinkFiveActiveSubscriptionData?>(
  stream: LinkFivePurchases.listenOnActiveSubscriptionData(),
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

```
// get LinkFivePurchases object from your provider or just create it
final linkFivePurchases = LinkFivePurchasesMain()

// get subscription data from your provider or from your stream (as described above)
LinkFiveSubscriptionData? linkFiveSubscriptionData = subscriptionData;

// you can use your own strings or use the intl package to automatically generate the subscription strings
final subscriptionListData = linkFiveSubscriptionData?.getSubscriptionData(context: context) ?? []

SimplePaywall(
    // ...
    callbackInterface: linkFivePurchases,
    subscriptionListData: subscriptionListData,
    // ...
});
```

Thats it. Now the page will automatically offer the subscriptions to the user or if the user already bought the subscription, the paywall will show the success page.

## Android Errors

if you get something like:

```
e: .../LinkFivePurchasesPlugin.kt: (89, 9): Class 'kotlin.Unit' was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.5.1, expected version is 1.1.15.
The class is loaded from .../.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib/1.5.0/29dae2501ca094416d15af0e21470cb634780444/kotlin-stdlib-1.5.0.jar!/kotlin/Unit.class
```

The SDK uses kotlin v1.5.0. You can change the kotlin version in your android/build.gradle file

```
buildscript {
    ...
    dependencies {
        ...
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.5.0"
    }
}
```

### Gradle

The sdk uses Gradle version 6.7.1
