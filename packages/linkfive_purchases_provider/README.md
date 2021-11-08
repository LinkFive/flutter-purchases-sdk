# LinkFive Provider Plugin

It wraps [linkfive_purchases](https://pub.dev/packages/linkfive_purchases) in an easy to use provider.

Please read our Blogpost [Subscriptions in Flutter - The Complete Implementation Guide](https://www.linkfive.io/flutter-blog/subscriptions-in-flutter-the-complete-implementation-guide)

All you need to do:

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

That‘s it. Simple enough?
