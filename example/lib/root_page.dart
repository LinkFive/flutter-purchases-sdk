import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/main.dart';
import 'package:linkfive_purchases_example/routing/delegate.dart';

class RootPage extends Page {
  RootPage() : super(key: ValueKey("RootPage"));

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return RootWidget();
        },
      );
}

class RootWidget extends StatefulWidget {
  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  Completer completer = Completer();

  @override
  void initState() {
    LinkFivePurchases.init(MyApp.linkFiveApiKey,
            logLevel: LinkFiveLogLevel.TRACE, env: LinkFiveEnvironment.STAGING)
        .then((value) => completer.complete(true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkFive Subscription Test App'),
      ),
      body: FutureBuilder(
          future: completer.future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator()],
              );
            }
            return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Raw Example"),
                      onPressed: () {
                        (Router.of(context).routerDelegate
                                as MainRouterDelegate)
                            .goToRawPayWall();
                      },
                    ),
                    ElevatedButton(
                      child: Text("Provider Simple UI Example"),
                      onPressed: () {
                        (Router.of(context).routerDelegate
                                as MainRouterDelegate)
                            .goToProviderSimplePayWall();
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text("Bloc Moritz UI Example"),
                          onPressed: () {
                            (Router.of(context).routerDelegate
                                    as MainRouterDelegate)
                                .goToBlocUI();
                          },
                        ),
                        ElevatedButton(
                          child: Text("Bloc RAW"),
                          onPressed: () {
                            (Router.of(context).routerDelegate
                                    as MainRouterDelegate)
                                .goToBlocRaw();
                          },
                        )
                      ],
                    )
                  ],
                ));
          }),
    );
  }
}
