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
