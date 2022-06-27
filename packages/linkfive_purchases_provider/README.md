# LinkFive Provider Plugin

It wraps [linkfive_purchases](https://pub.dev/packages/linkfive_purchases) in an easy to use provider.

Please read our Blogpost [Subscriptions in Flutter - The Complete Implementation Guide](https://www.linkfive.io/flutter-blog/subscriptions-in-flutter-the-complete-implementation-guide/)

or [LinkFive Provider Example Documentation](https://www.linkfive.io/docs/flutter/provider-example/)


## Register the Provider

Register the Provider with our API key and you're all set to use it.

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

## Load Products

Whenever you want to offer your product, call `fetchProducts()` to load the latest products.


## Use the products in your UI:

```dart
Consumer<LinkFiveProvider>(builder: (_, linkFiveProvider, __) {
  // linkFiveProvider.products if you want to show your subscription offer
  // linkFiveProvider.activeProducts if a user purchased a subscription
}
```

or access in a button tap or in a stateful widget

```dart
LinkFiveProvider linkFiveProvider = Provider.of<LinkFiveProvider>(context, listen: false);
```

That‘s it. Simple enough?
