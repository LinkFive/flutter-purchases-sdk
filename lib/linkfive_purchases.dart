
import 'dart:async';

import 'package:flutter/services.dart';

class LinkfivePurchases {
  static const MethodChannel _channel =
      const MethodChannel('linkfive_purchases');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
