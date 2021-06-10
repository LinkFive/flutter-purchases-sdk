import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';

class LinkFivePurchases {
  static const MethodChannel _channel = const MethodChannel('linkfive_methods');
  static const EventChannel _channelEvent = const EventChannel("linkfive_events");

  static init({apiKey, acknowledgeLocally = false, fetchSubscription = false}) async {
    await _channel.invokeMethod('linkfive_init', <String, dynamic>{
      'apiKey': apiKey,
      'acknowledgeLocally': acknowledgeLocally,
    });
    if (fetchSubscription) {
      await LinkFivePurchases.fetchSubscription();
    }
  }

  static fetchSubscription() async {
    await _channel.invokeMethod('linkfive_fetch');
  }

  static Stream<LinkFiveResponseData> linkFiveResponse() {
    var controller = StreamController<LinkFiveResponseData>();
    _channelEvent.receiveBroadcastStream().listen((event) {
      controller.add(LinkFiveResponseData.fromJson(event));
    });

    return controller.stream;
  }
}
