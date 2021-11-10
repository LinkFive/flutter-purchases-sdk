import 'package:flutter/material.dart';
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

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkFive Subscription Test App'),
      ),
      body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Raw Example"),
                onPressed: () {
                  (Router.of(context).routerDelegate as MainRouterDelegate)
                      .goToRawPayWall();
                },
              ),
              ElevatedButton(
                child: Text("Provider Simple UI Example"),
                onPressed: () {
                  (Router.of(context).routerDelegate as MainRouterDelegate)
                      .goToProviderSimplePayWall();
                },
              ),
              ElevatedButton(
                child: Text("Bloc Moritz UI Example"),
                onPressed: () {
                  (Router.of(context).routerDelegate as MainRouterDelegate)
                      .goToBlocMoritzPayWall();
                },
              ),
            ],
          )),
    );
  }
}
