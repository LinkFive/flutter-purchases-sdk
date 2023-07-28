import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchases_intl/delegate/paywall_localizations.dart';
import 'package:linkfive_purchases_example/key/keyLoader.dart';
import 'package:linkfive_purchases_example/routing/delegate.dart';
import 'package:linkfive_purchases_example/routing/parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();

  /// convenient prop to not always have the future hussle
  static late String linkFiveApiKey;
}

class MyAppState extends State<MyApp> {
  MainRouterDelegate _delegate = MainRouterDelegate();
  AppPathInformationParser _parser = AppPathInformationParser();

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
            // for convenient save to static prop
            MyApp.linkFiveApiKey = snapshot.data!.linkFiveApiKey;
            print(snapshot.data!.linkFiveApiKey);

            return MaterialApp(
              title: 'LinkFive Example App',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              localizationsDelegates: [
                PaywallLocalizations.delegate,
              ],
              home: MaterialApp.router(
                routeInformationParser: _parser,
                routerDelegate: _delegate,
                theme: ThemeData(primarySwatch: Colors.green, iconTheme: IconThemeData(color: Colors.green)),
              ),
            );
          }
          // loading
          return MaterialApp(
              home: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          ));
        });
  }
}
