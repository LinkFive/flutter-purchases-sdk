import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';
import 'package:provider/provider.dart';

class ProviderSimplePaywall extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer<LinkFiveProvider>(builder: (_, linkFiveProvider, __) {
      return PaywallScaffold(
          appBarTitle: "LinkFive Premium",
          child: SimplePaywall(
              theme: Theme.of(context),
              callbackInterface: linkFiveProvider.callbackInterface,
              subscriptionListData:
                  linkFiveProvider.paywallUIHelperData(context),
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
  }
}
