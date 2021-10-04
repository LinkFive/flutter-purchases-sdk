import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/logic/linkfive_purchases_main.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

/// LinkFive Purchases.
class LinkFivePurchases {
  /// Init LinkFive with your API Key
  /// [LinkFiveLogLevel] to see or hide internal logging
  /// [LinkFiveEnvironment] is 99,999..% [LinkFiveEnvironment.PRODUCTION] better not touch it
  static init(
    String apiKey, {
    LinkFiveLogLevel logLevel = LinkFiveLogLevel.DEBUG,
    LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION,
  }) {
    return LinkFivePurchasesMain().init(apiKey, logLevel: logLevel, env: env);
  }

  /// Fetch all available Subscription for purchase for the user
  /// All Data will be send to the stream
  static fetchSubscriptions() {
    return LinkFivePurchasesMain().fetchSubscriptions();
  }

  /// Restore Subscriptions of the user
  /// All Data will be send to the stream
  static Future<void> restore() async {
    await LinkFivePurchasesMain().restore();
  }

  /// make a purchase
  /// A purchase will be send to the stream
  /// The future returns if the "purchase screen" is visible to the user
  /// and not if the purchase was successful
  static Future<bool> purchase(ProductDetails productDetails) async {
    return LinkFivePurchasesMain().purchase(productDetails);
  }

  /// LinkFive Server Response Data as Stream
  static Stream<LinkFiveResponseData?> listenOnResponseData() =>
      LinkFivePurchasesMain().listenOnResponseData();

  /// Subscription Data to offer to the user
  static Stream<LinkFiveSubscriptionData?> listenOnSubscriptionData() =>
      LinkFivePurchasesMain().listenOnSubscriptionData();

  /// if the user has an active verified purchase, then this stream will deliver
  /// the active and verified purchase
  static Stream<LinkFiveActiveSubscriptionData?>
      listenOnActiveSubscriptionData() =>
          LinkFivePurchasesMain().listenOnActiveSubscriptionData();

  /// Set the UTM source of a user
  /// You can filter this value in your playout
  static setUTMSource(String? utmSource) {
    LinkFivePurchasesMain().setUTMSource(utmSource);
  }

  /// Set your environment
  /// You can filter this value in your playout
  static setEnvironment(String? environment) {
    LinkFivePurchasesMain().setEnvironment(environment);
  }

  /// set the user ID
  /// You can filter this value in your playout
  static setUserId(String? userId) {
    LinkFivePurchasesMain().setUserId(userId);
  }
}
