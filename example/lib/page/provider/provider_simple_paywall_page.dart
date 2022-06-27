import 'package:flutter/material.dart';
import 'package:linkfive_purchases_example/main.dart';
import 'package:linkfive_purchases_example/page/provider/provider_simple_paywall.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';

class ProviderSimplePaywallPage extends Page {
  ProviderSimplePaywallPage(): super(key: ValueKey("ProviderSimplePaywallPage"));

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (context) => LinkFiveProvider(MyApp.linkFiveApiKey),
            lazy: false,
          )
        ], child: ProviderSimplePaywall());
      });

}
