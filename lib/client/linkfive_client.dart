import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class LinkFiveClient {
  final String stagingUrl = "api.staging.linkfive.io";
  final String prodUrl = "api.linkfive.io";

  String hostUrl = "api.staging.linkfive.io";

  Future<LinkFiveResponseData> fetchLinkFiveResponse(String apiKey) async {
    var path = "api/v1/subscriptions";
    var uri = Uri.https(hostUrl, path);
    var response = await http.get(uri, headers: {
      "authorization": "Bearer $apiKey",
      "X-Platform": _getPlatform(),
      "X-Country": _getCountryCode(),
      "X-App-Version": await _getAppVersion()
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var mapBody = jsonDecode(response.body);
    var data = mapBody["data"];
    var linkFiveResponseData = LinkFiveResponseData.fromJson(data);
    return linkFiveResponseData;
  }

  sendPurchaseToServer(String apiKey, PurchaseDetails purchaseDetails) {
    print(purchaseDetails);
    if (purchaseDetails is GooglePlayPurchaseDetails) {
      _sendGooglePlayPurchaseToServer(apiKey, purchaseDetails);
    }
  }

  _sendGooglePlayPurchaseToServer(String apiKey, GooglePlayPurchaseDetails googlePlayPurchaseDetails) async {
    var path = "api/v1/purchases/google/verify";
    var uri = Uri.https(hostUrl, path);

    final body = {
      "packageName": googlePlayPurchaseDetails.billingClientPurchase.packageName,
      "purchaseToken": googlePlayPurchaseDetails.billingClientPurchase.purchaseToken,
      "orderId": googlePlayPurchaseDetails.billingClientPurchase.orderId,
      "purchaseTime": googlePlayPurchaseDetails.billingClientPurchase.purchaseTime,
      "sku": googlePlayPurchaseDetails.billingClientPurchase.sku,
    };

    var response = await http.post(uri, body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $apiKey",
      "X-Platform": _getPlatform(),
      "X-Country": _getCountryCode(),
      "X-App-Version": await _getAppVersion(),
    });
    print(response.body);
  }

  Future<LinkFiveActiveSubscriptionData> fetchSubscriptionDetails(
    String apiKey,
    List<PurchaseDetails> purchasedProducts,
  ) async {
    var path = "api/v1/subscription/sku";
    final queryParams = {"sku": purchasedProducts.map((e) => e.productID).toList()};
    var uri = Uri.https(hostUrl, path, queryParams);

    var response = await http.get(uri, headers: {
      "authorization": "Bearer $apiKey",
      "X-Platform": _getPlatform(),
      "X-Country": _getCountryCode(),
      "X-App-Version": await _getAppVersion()
    });
    print(response.body);
    return LinkFiveActiveSubscriptionData.fromJson(jsonDecode(response.body)["data"]);
  }

  String _getPlatform() {
    if (Platform.isAndroid) {
      return "GOOGLE";
    }
    if (Platform.isIOS) {
      return "IOS";
    }
    return "UNKNOWN";
  }

  String _getCountryCode() {
    return WidgetsBinding.instance?.window.locale.countryCode ?? "";
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> _getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }
}
