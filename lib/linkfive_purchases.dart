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


  // last Responses used to provide to the next stream
  static LinkFiveResponseData? _lastLinkFiveResponseData = null;
  static LinkFiveSubscriptionData? _lastLinkFiveSubscriptionData = null;
  static LinkFiveActiveSubscriptionData? _lastLinkFiveActiveSubscriptionData = null;

  // Stream to flutter of Raw Response
  static StreamController<LinkFiveResponseData?>? _streamControllerResponse = null;

  // Stream to flutter of Subscription data
  static StreamController<LinkFiveSubscriptionData?>? _streamControllerSubscriptions = null;

  // Stream to flutter of Active Subscription data
  static StreamController<LinkFiveActiveSubscriptionData?>? _streamControllerActiveSubscriptions = null;

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
      _lastLinkFiveResponseData = LinkFiveResponseData.fromJson(event);
      _streamControllerResponse?.add(_lastLinkFiveResponseData);
    });
    _channelEventSubscription.receiveBroadcastStream().listen((event) {
      _lastLinkFiveSubscriptionData = LinkFiveSubscriptionData.fromJson(event);
      _streamControllerSubscriptions?.add(_lastLinkFiveSubscriptionData);
    });
    _channelEventActiveSubscription.receiveBroadcastStream().listen((event) {
      _lastLinkFiveActiveSubscriptionData = LinkFiveActiveSubscriptionData.fromJson(event);
      _streamControllerActiveSubscriptions?.add(_lastLinkFiveActiveSubscriptionData);
    });
  }

  /// Fetches the available subscriptions
  static fetchSubscription() async {
    await _channel.invokeMethod('linkfive_fetch', <String, dynamic>{
      'apiKey': "apiKey",
      'acknowledgeLocally': "acknowledgeLocally",
    });
  }

  /// Purchase the product
  static purchase({required SkuDetails skuDetails}) async {
    print("purchase with ${skuDetails.sku}");
    await _channel.invokeMethod("linkfive_purchase", <String, dynamic>{
      'sku': skuDetails.sku,
      'type': skuDetails.type,
    });
  }

  /// LinkFive Response Stream
  /// This includes the playout raw data
  static Stream<LinkFiveResponseData?> linkFiveResponse() {
    _streamControllerResponse = StreamController<LinkFiveResponseData>();
    if(_lastLinkFiveResponseData != null) {
      _streamControllerResponse!.add(_lastLinkFiveResponseData);
    }
    return _streamControllerResponse!.stream;
  }

  /// Available Subscription Stream
  /// This includes store data and attributes
  static Stream<LinkFiveSubscriptionData?> linkFiveSubscription() {
    _streamControllerSubscriptions = StreamController<LinkFiveSubscriptionData>();
    if(_lastLinkFiveSubscriptionData != null) {
      _streamControllerSubscriptions!.add(_lastLinkFiveSubscriptionData);
    }
    return _streamControllerSubscriptions!.stream;
  }

  /// Active Subscription Stream
  /// When a users purchases a product, the stream contains purchase data
  static Stream<LinkFiveActiveSubscriptionData?> linkFiveActiveSubscription() {
    _streamControllerActiveSubscriptions = StreamController<LinkFiveActiveSubscriptionData>();
    if(_lastLinkFiveActiveSubscriptionData != null) {
      _streamControllerActiveSubscriptions!.add(_lastLinkFiveActiveSubscriptionData);
    }
    return _streamControllerActiveSubscriptions!.stream;
  }
}
