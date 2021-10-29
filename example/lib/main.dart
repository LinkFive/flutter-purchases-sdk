import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkfive_purchases_example/key/keyLoader.dart';

import 'package:linkfive_purchases_example/routing/delegate.dart';
import 'package:linkfive_purchases_example/routing/parser.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
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
            print(snapshot.data!.linkFiveApiKey);
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => LinkFiveProvider(snapshot.data!.linkFiveApiKey, environment: LinkFiveEnvironment.STAGING),
                    lazy: false,
                  )
                ],
                child: MaterialApp(
                  title: 'LinkFive Example App',
                  theme: ThemeData(
                    primarySwatch: Colors.green,
                  ),
                  home: MaterialApp.router(
                    routeInformationParser: _parser,
                    routerDelegate: _delegate,
                    theme: ThemeData(
                        primarySwatch: Colors.green,
                        iconTheme: IconThemeData(color: Colors.green)),
                  ),
                ));
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
