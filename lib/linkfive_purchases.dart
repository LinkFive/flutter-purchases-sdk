import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/logic/linkfive_purchases_main.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

class LinkFivePurchases {
  /// Init LinkFive with your API Key
  static init(
    String apiKey, {
    LinkFiveLogLevel logLevel = LinkFiveLogLevel.DEBUG,
    LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION,
  }) {
    return LinkFivePurchasesMain().init(apiKey, logLevel: logLevel, env: env);
  }

  static fetchSubscriptions() {
    return LinkFivePurchasesMain().fetchSubscriptions();
  }

  static Future<void> restore() async {
    await LinkFivePurchasesMain().restore();
  }

  static purchase(ProductDetails productDetails) async {
    return LinkFivePurchasesMain().purchase(productDetails);
  }

  static Stream<LinkFiveResponseData?> listenOnResponseData() => LinkFivePurchasesMain().listenOnResponseData();

  static Stream<LinkFiveSubscriptionData?> listenOnSubscriptionData() =>
      LinkFivePurchasesMain().listenOnSubscriptionData();

  static Stream<LinkFiveActiveSubscriptionData?> listenOnActiveSubscriptionData() =>
      LinkFivePurchasesMain().listenOnActiveSubscriptionData();

  static setUTMSource(String? utmSource) {
    LinkFivePurchasesMain().setUTMSource(utmSource);
  }

  static setEnvironment(String? environment) {
    LinkFivePurchasesMain().setEnvironment(environment);
  }

  static setUserId(String? userId) {
    LinkFivePurchasesMain().setUserId(userId);
  }
}
