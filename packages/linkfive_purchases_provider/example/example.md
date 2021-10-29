
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