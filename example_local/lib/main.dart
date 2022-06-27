import 'dart:async';

import 'package:example_local/key/keyLoader.dart';
import 'package:example_local/subscriptions/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Completer<Keys> _keysCompleter = Completer<Keys>();
  late Future<Keys> _keysFuture;

  MyAppState() {
    _keysFuture = _keysCompleter.future;
  }

  @override
  void initState() {
    _keysCompleter.complete(KeyLoader().load(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Keys>(
        future: _keysFuture,
        builder: (BuildContext context, AsyncSnapshot<Keys> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.linkFiveApiKey);
            LinkFivePurchasesMain().init(snapshot.data!.linkFiveApiKey,
                    logLevel: LinkFiveLogLevel.TRACE,
                    env: LinkFiveEnvironment.STAGING);
                LinkFivePurchases.fetchProducts();

            return MaterialApp(
                title: 'LinkFive Example App',
                theme: ThemeData(
                  primarySwatch: Colors.green,
                ),
                home: Scaffold(
                    appBar: AppBar(
                      title: Text("Hello"),
                    ),
                    body: SubscriptionPage()));
          }
          // loading
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          );
        });
  }
}
