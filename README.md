# LinkFive Purchases flutter sdk

## Getting Started

Initialize the SDK
```dart
LinkFivePurchases.init("LinkFive Api Key");
```

fetch all available subscripton:
```dart
LinkFivePurchases.fetchSubscriptions();
```

### Available Subscription Data

LinkFive uses a stream to pass data to your application. You can either just use the stream or use a StreamBuilder

```dart
StreamBuilder<LinkFiveSubscriptionData?>(
  stream: LinkFivePurchases.listenOnSubscriptionData(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      var subscriptionData = snapshot.data;
      if(subscriptionData != null) {
        // do something
      }
    }
    return Center(child: Text('Loading...'));
  },
```

### Purchase a Subscription
Just call purchase including the skuDetails
```dart
makePurchase(LinkFiveProductDetails linkFiveProductDetails) async {
  await LinkFivePurchases.purchase(linkFiveProductDetails.productDetails);
}
```

### Get Active Subscription Data
You will receive the data through the active subscription stream. You can either just use the stream or use a StreamBuilder
```dart
LinkFivePurchases.listenOnActiveSubscriptionData().listen(_activeSubscriptionListener);

///
/// subscriptionData can be null
///
void _activeSubscriptionListener(LinkFiveActiveSubscriptionData? subscriptionData) async {
  // active Subscription
}
```

### Restore Purchases
All restored subscriptions will be available through the activeSubscription listener
```dart
LinkFivePurchases.restore();
```

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