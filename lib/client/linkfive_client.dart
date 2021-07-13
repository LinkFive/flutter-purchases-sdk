import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import 'package:linkfive_purchases/logger/linkfive_logger.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_verified_receipt.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class LinkFiveClient {
  final String stagingUrl = "api.staging.linkfive.io";
  final String prodUrl = "api.linkfive.io";

  LinkFiveEnvironment environment = LinkFiveEnvironment.PRODUCTION;

  String hostUrl = "api.staging.linkfive.io";
  late String _apiKey;

  String get _platform {
    if (Platform.isAndroid) {
      return "GOOGLE";
    }
    if (Platform.isIOS) {
      return "IOS";
    }
    return "UNKNOWN";
  }

  String get _countryCode {
    return WidgetsBinding.instance?.window.locale.countryCode ?? "";
  }

  Future<String> get _appVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<Map<String, String>> get _headers async {
    return {
      "Content-Type": "application/json",
      "authorization": "Bearer $_apiKey",
      "X-Platform": _platform,
      "X-Country": _countryCode,
      "X-App-Version": await _appVersion
    };
  }

  init(LinkFiveEnvironment env, String apiKey) {
    environment = env;
    _apiKey = apiKey;
    if (env == LinkFiveEnvironment.STAGING) {
      hostUrl = stagingUrl;
    } else {
      hostUrl = prodUrl;
    }
  }

  Future<LinkFiveResponseData> fetchLinkFiveResponse() async {
    final uri = _makeUri("api/v1/subscriptions");

    final response = await http.get(uri, headers: await _headers);
    LinkFiveLogger.d('Response status: ${response.statusCode}');
    LinkFiveLogger.d('Response body: ${response.body}');
    final mapBody = jsonDecode(response.body);
    final data = mapBody["data"];
    final linkFiveResponseData = LinkFiveResponseData.fromJson(data);
    return linkFiveResponseData;
  }

  sendPurchaseToServer(PurchaseDetails purchaseDetails) {
    LinkFiveLogger.d(purchaseDetails);
    if (purchaseDetails is GooglePlayPurchaseDetails) {
      _sendGooglePlayPurchaseToServer(purchaseDetails);
    }
  }

  Future<LinkFiveVerifiedReceipt> verifyAppleReceipt(String receipt) async {
    final uri = _makeUri("api/v1/purchases/apple/verify");
    final body = {"receipt": receipt};

    final response =
        await http.post(uri, body: jsonEncode(body), headers: await _headers);
    LinkFiveLogger.d(response.body);

    return LinkFiveVerifiedReceipt.fromJson(jsonDecode(response.body)["data"]);
  }

  Future<LinkFiveActiveSubscriptionData> fetchSubscriptionDetails(
    List<String> productIds,
  ) async {
    final queryParams = {"sku": productIds};
    final uri = _makeUri("api/v1/subscription/sku", queryParams: queryParams);

    final response = await http.get(uri, headers: await _headers);
    LinkFiveLogger.d(response.body);
    return LinkFiveActiveSubscriptionData.fromJson(
        jsonDecode(response.body)["data"]);
  }

  _sendGooglePlayPurchaseToServer(
      GooglePlayPurchaseDetails googlePlayPurchaseDetails) async {
    final uri = _makeUri("api/v1/purchases/google/verify");

    final body = {
      "packageName":
          googlePlayPurchaseDetails.billingClientPurchase.packageName,
      "purchaseToken":
          googlePlayPurchaseDetails.billingClientPurchase.purchaseToken,
      "orderId": googlePlayPurchaseDetails.billingClientPurchase.orderId,
      "purchaseTime":
          googlePlayPurchaseDetails.billingClientPurchase.purchaseTime,
      "sku": googlePlayPurchaseDetails.billingClientPurchase.sku,
    };

    final response =
        await http.post(uri, body: jsonEncode(body), headers: await _headers);
    LinkFiveLogger.d(response.body);
  }

  Uri _makeUri(String path, {Map<String, List<String>>? queryParams}) {
    if (queryParams == null) {
      return Uri.https(hostUrl, path);
    }

    return Uri.https(hostUrl, path, queryParams);
  }
}

enum LinkFiveEnvironment { STAGING, PRODUCTION }
