import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_active_products_cubit.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_active_products_state.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_products_cubit.dart';
import 'package:linkfive_purchases_example/bloc/linkfive_products_state.dart';
import 'package:linkfive_purchases_provider/linkfive_purchases_provider.dart';
import 'package:provider/provider.dart';

class BlocPaywall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<LinkFiveProductsCubit, LinkFiveProductsState>(
        builder: (context, state) {
      // empty list if no data available
      List<SubscriptionData> subscriptionData = [];

      // check for the loaded state and set the data
      if (state is LinkFiveProductsLoadedState) {
        subscriptionData = state.products.getSubscriptionData(context: context);
      }

      return PaywallScaffold(
          appBarTitle: "LinkFive Premium",
          child: MoritzPaywall(
              theme: Theme.of(context),
              callbackInterface: LinkFivePurchases.callbackInterface,
              subscriptionListData: subscriptionData,
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
              tosData:
                  TextAndUrl("Terms of Service", "https://www.linkfive.io/tos"),
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
