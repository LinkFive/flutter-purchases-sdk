import 'dart:async';

import 'package:flutter/services.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';

class LinkFivePurchases {
  // Native method channel for e.g. init
  static const MethodChannel _channel = const MethodChannel('linkfive_methods');

  // Native channel to receive the Raw LinkFive Response
  static const EventChannel _channelEventResponse = const EventChannel("linkfive_events_response");

  // Native channel to receive Subscription Data like prices etc.
  static const EventChannel _channelEventSubscription = const EventChannel("linkfive_events_subscription");

  // Native channel to receive Active Subscription Data
  static const EventChannel _channelEventActiveSubscription = const EventChannel("linkfive_events_active_subscription");

  // Stream to flutter of Raw Response
  static StreamController<LinkFiveResponseData>? _streamControllerResponse = null;

  // Stream to flutter of Subscription data
  static StreamController<LinkFiveSubscriptionData>? _streamControllerSubscriptions = null;

  // Stream to flutter of Active Subscription data
  static StreamController<LinkFiveActiveSubscriptionData>? _streamControllerActiveSubscriptions = null;

  /// initialize the SDK
  ///
  /// * [apiKey] api key
  /// * acknowledgeLocally default = false. if true the sdk will acknowledge locally instead waiting for the server
  /// * fetch subscription default = false. if true fetch subscription will be called after initialize the sdk
  static init(String apiKey, {bool acknowledgeLocally = false, bool fetchSubscription = false}) async {
    await _channel.invokeMethod('linkfive_init', <String, dynamic>{
      'apiKey': apiKey,
      'acknowledgeLocally': acknowledgeLocally,
    });
    if (fetchSubscription) {
      await LinkFivePurchases.fetchSubscription();
    }
    print("INIT SDK");
    _channelEventResponse.receiveBroadcastStream().listen((event) {
      print("try to send to $_streamControllerResponse");
      _streamControllerResponse?.add(LinkFiveResponseData.fromJson(event));
    });
    _channelEventSubscription.receiveBroadcastStream().listen((event) {
      _streamControllerSubscriptions?.add(LinkFiveSubscriptionData.fromJson(event));
    });
    _channelEventActiveSubscription.receiveBroadcastStream().listen((event) {
      print(event);
      _streamControllerActiveSubscriptions?.add(LinkFiveActiveSubscriptionData.fromJson(event));
    });
  }

  // Fetches the available subscriptions from LinkFive and from the store
  static fetchSubscription() async {
    await _channel.invokeMethod('linkfive_fetch', <String, dynamic>{
      'apiKey': "apiKey",
      'acknowledgeLocally': "acknowledgeLocally",
    });
  }

  static purchase({required SkuDetails skuDetails}) async {
    await _channel.invokeMethod("linkfive_purchase", <String, dynamic>{
      'sku': skuDetails.sku,
      'type': skuDetails.type,
    });
  }

  static Stream<LinkFiveResponseData> linkFiveResponse() {
    _streamControllerResponse = StreamController<LinkFiveResponseData>();
    return _streamControllerResponse!.stream;
  }

  static Stream<LinkFiveSubscriptionData> linkFiveSubscription() {
    _streamControllerSubscriptions = StreamController<LinkFiveSubscriptionData>();
    return _streamControllerSubscriptions!.stream;
  }

  static Stream<LinkFiveActiveSubscriptionData> linkFiveActiveSubscription() {
    _streamControllerActiveSubscriptions = StreamController<LinkFiveActiveSubscriptionData>();
    return _streamControllerActiveSubscriptions!.stream;
  }
}
