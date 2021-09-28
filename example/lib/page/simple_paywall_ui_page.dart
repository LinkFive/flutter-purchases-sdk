import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases_example/provider/linkfive_provider.dart';
import 'package:provider/provider.dart';

class SimplePayWallUiPage extends Page {
  SimplePayWallUiPage() : super(key: ValueKey("SimplePayWallUiPage"));

  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return SimplePayWallUIWidget();
        },
      );
}

class SimplePayWallUIWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LinkFiveProvider>(builder: (_, linkFiveProvider, __) {
      LinkFiveSubscriptionData? linkFiveSubscriptionData = linkFiveProvider.linkFiveSubscriptionData;
      return SimplePayWallUiElement(
        linkFiveProvider,
        linkFiveSubscriptionData,
        appBarTitle: "Premium",
        title: "Go Premium",
        subTitle: "All features now",
      );
    });
  }
}

class SimplePayWallUiElement extends StatelessWidget {
  final String? appBarTitle;
  final String? title;
  final String? subTitle;
  final TextAndUrl? tosData;
  final TextAndUrl? ppData;
  final Widget? headerContainer;
  final List<IconAndText>? bulletPoints;
  final Widget? campaignWidget;
  final String? restoreText;

  SimplePayWallUiElement(this.linkFiveProvider, this.linkFiveSubscriptionData,
      {this.appBarTitle,
      this.title,
      this.subTitle,
      this.tosData,
      this.ppData,
      this.headerContainer,
      this.bulletPoints,
      this.campaignWidget,
      this.restoreText});

  final LinkFiveProvider linkFiveProvider;
  final LinkFiveSubscriptionData? linkFiveSubscriptionData;

  //#region subscriptions getter
  List<LinkFiveProductDetails> get _skuData => linkFiveSubscriptionData?.linkFiveSkuData ?? [];

  List<SubscriptionData> get _subscriptionDataList => _skuData
      .map((lfProductDetails) => SubscriptionData(durationTitle: "year", durationShort: "1y", price: "2monate"))
      .toList();

  //#endregion

  //#region attributes getter
  String get _attributesString => linkFiveSubscriptionData?.attributes ?? "{}";

  Map<String, dynamic> get _attributesParsed {
    try {
      return jsonDecode(utf8.decode(base64.decode(_attributesString)));
    } catch (e) {
      print(e);
    }
    return {};
  }

  Map<String, dynamic> get _attributesPaywall {
    try {
      return _attributesParsed["paywall"] as Map<String, dynamic>;
    } catch (e) {
      print(e);
    }
    return {};
  }

  //#endregion

  Widget get _emptyData => Container(child: Column(children: [CircularProgressIndicator()]));

  @override
  Widget build(BuildContext context) {
    if (linkFiveSubscriptionData != null) {
      Map<String, dynamic> attributesMap = _attributesPaywall;
      String? appBarTitle = attributesMap["app.bar.title"] ?? this.appBarTitle;
      String? title = attributesMap["title"] ?? this.title;
      String? subTitle = attributesMap["sub.title"] ?? this.subTitle;
      // bullet points
      List<dynamic>? bulletPoints =
          attributesMap["bullet.points"] == null ? null : attributesMap["bullet.points"] as List<dynamic>;
      List<IconAndText>? iconAndTextList;
      if (bulletPoints != null) {
        iconAndTextList = bulletPoints
            .map((value) => value as Map<String, dynamic>)
            .map((value) => IconAndText(
                IconData(int.parse('0x${value["icon.hex"]}'), fontFamily: 'MaterialIcons'), value["text"] ?? ""))
            .toList();
      } else {
        iconAndTextList = this.bulletPoints;
      }

      String? tosText = attributesMap["tos.text"];
      String? tosURL = attributesMap["tos.url"];
      String? ppText = attributesMap["pp.text"];
      String? ppURL = attributesMap["pp.url"];

      TextAndUrl? tos;
      TextAndUrl? pp;

      if (tosText != null && tosURL != null) {
        tos = TextAndUrl(tosText, tosURL);
      } else {
        tos = tosData;
      }

      if (ppText != null && ppURL != null) {
        tos = TextAndUrl(ppText, ppURL);
      } else {
        tos = ppData;
      }

      return Container(
        child: SimplePayWallScaffold(
          theme: Theme.of(context),
          callbackInterface: linkFiveProvider.linkFivePurchases,
          subscriptionListData: _subscriptionDataList,
          appBarTitle: appBarTitle,
          // Title Bar
          title: title,
          // SubTitle
          subTitle: subTitle,
          // Add as many bullet points as you like
          bulletPoints: iconAndTextList,
          tosData: tos,
          // provide your PP
          ppData: pp,
        ),
      );
    }
    return Container(
        child: SimplePayWallScaffold(
      theme: Theme.of(context),
      isSubscriptionLoading: true,
    ));
  }
}
