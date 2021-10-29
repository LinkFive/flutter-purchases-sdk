# Examples

## Provider Example

Now also as a standalone package: [linkfive_purchases_provider](https://pub.dev/packages/linkfive_purchases_provider)

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/key/keyLoader.dart';

class LinkFiveProvider extends ChangeNotifier {
  LinkFivePurchasesMain linkFivePurchases = LinkFivePurchasesMain();

  LinkFiveResponseData? linkFiveResponseData = null;
  LinkFiveSubscriptionData? linkFiveSubscriptionData = null;
  LinkFiveActiveSubscriptionData? linkFiveActiveSubscriptionData = null;

  List<StreamSubscription> _streams = [];

  LinkFiveProvider(Keys keys) {
    linkFivePurchases.init(keys.linkFiveApiKey);
    linkFivePurchases.fetchSubscriptions();
    _streams.add(linkFivePurchases.listenOnResponseData().listen(_responseDataUpdate));
    _streams.add(linkFivePurchases.listenOnSubscriptionData().listen(_subscriptionDataUpdate));
    _streams.add(linkFivePurchases.listenOnActiveSubscriptionData().listen(_activeSubscriptionDataUpdate));
  }

  void _responseDataUpdate(LinkFiveResponseData? data) {
    linkFiveResponseData = data;
    notifyListeners();
  }

  void _subscriptionDataUpdate(LinkFiveSubscriptionData? data) async {
    linkFiveSubscriptionData = data;
    notifyListeners();
  }

  void _activeSubscriptionDataUpdate(LinkFiveActiveSubscriptionData? data) {
    linkFiveActiveSubscriptionData = data;
    notifyListeners();
  }

  @override
  void dispose() {
    _streams.forEach((element) async {
      await element.cancel();
    });
    _streams = [];
    super.dispose();
  }
}
```

## Use the provider and show the UI
This example uses Navigation 2.0

```dart
import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/provider/linkfive_provider.dart';
import 'package:provider/provider.dart';

class SimplePaywallUiPage extends Page {
  SimplePaywallUiPage() : super(key: ValueKey("SimplePayWallUiPage"));

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return Consumer<LinkFiveProvider>(builder: (_, linkFiveProvider, __) {
            return PaywallScaffold(
                appBarTitle: "LinkFive Premium",
                child: SimplePaywall(
                    theme: Theme.of(context),
                    callbackInterface: linkFiveProvider.callbackInterface,
                    subscriptionListData: linkFiveProvider.getSubscriptionListData(context),
                    title: "Go Premium",
                    // SubTitle
                    subTitle: "All features at a glance",
                    // Add as many bullet points as you like
                    bulletPoints: [
                      IconAndText(Icons.stop_screen_share_outlined, "No Ads"),
                      IconAndText(Icons.hd, "Premium HD"),
                      IconAndText(Icons.sort, "Access to All Premium Articles")
                    ],
                    // Shown if isPurchaseSuccess == true
                    successTitle: "You're a Premium User!",
                    // Shown if isPurchaseSuccess == true
                    successSubTitle: "Thanks for your Support!",
                    // Widget can be anything. Shown if isPurchaseSuccess == true
                    successWidget: Container(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child: Text("Let's go!"),
                                onPressed: () {
                                  print("let‘s go to the home widget again");
                                },
                              )
                            ])),
                    tosData: TextAndUrl(
                        "Terms of Service", "https://www.linkfive.io/tos"),
                    // provide your PP
                    ppData: TextAndUrl(
                        "Privacy Policy", "https://www.linkfive.io/privacy"),
                    // add a custom campaign widget
                    campaignWidget: CampaignBanner(
                      theme: Theme.of(context),
                      headline: "🥳 Summer Special Sale",
                    )));
          });
        },
      );
}

```