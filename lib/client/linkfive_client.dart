import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import 'package:linkfive_purchases/logger/linkfive_logger.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';

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

  Future<String> get _packageName async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<Map<String, String>> get _headers async {
    return {
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
    } else if (purchaseDetails is AppStorePurchaseDetails) {
      // TODO: What to do?
      SKPaymentTransactionWrapper skProduct =
          (purchaseDetails as AppStorePurchaseDetails).skPaymentTransaction;

      print(skProduct.transactionState);
    }
  }

  Future<LinkFiveActiveSubscriptionData> fetchSubscriptionDetails(
    List<PurchaseDetails> purchasedProducts,
  ) async {
    final queryParams = {
      "sku": purchasedProducts.map((e) => e.productID).toList()
    };
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

  _verifyAppleReceipt() {
    final uri = _makeUri("api/v1/purchases/ios/verify");
  }

  Uri _makeUri(String path, {Map<String, List<String>>? queryParams}) {
    if (queryParams == null) {
      return Uri.https(hostUrl, path);
    }

    return Uri.https(hostUrl, path, queryParams);
  }
}

enum LinkFiveEnvironment { STAGING, PRODUCTION }
