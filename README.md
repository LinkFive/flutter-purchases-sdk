# LinkFive Purchases flutter sdk

## Getting Started

Initialize the SDK
```dart
LinkFivePurchases.init("LinkFive Api Key");
```

fetch all available subscripton:
```dart
LinkFivePurchases.fetchSubscription();
```

You can also initialize the sdk and fetch all subscription in one call
```dart
LinkFivePurchases.init(keys.linkFiveApiKey, fetchSubscription: true);
```


### Available Subscription Data

LinkFive uses a stream to pass data to your application. You can either just use the stream or use a StreamBuilder

```dart
StreamBuilder(
  stream: LinkFivePurchases.linkFiveSubscription(),
  builder: (BuildContext context, AsyncSnapshot<LinkFiveSubscriptionData> snapshot) {
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
LinkFivePurchases.purchase(skuDetails: linkFiveSkuData.skuDetails);
```

### Get Active Subscription Data
You will receive the data through the active subscription stream. You can either just use the stream or use a StreamBuilder
```dart
StreamBuilder(
  stream: LinkFivePurchases.linkFiveActiveSubscription(),
  builder: (BuildContext context, AsyncSnapshot<LinkFiveActiveSubscriptionData> snapshot) {
    if (snapshot.hasData) {
      var subscriptionData = snapshot.data;
      if (subscriptionData != null) {
        // do something
      }
    }
    return Center(child: Text('Loading...'));
  },
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