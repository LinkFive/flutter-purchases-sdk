# LinkFive Provider Plugin

It wraps [linkfive_purchases](https://pub.dev/packages/linkfive_purchases) in an easy to use provider

All you need to do:

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

That‘s it.