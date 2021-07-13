import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import 'package:linkfive_purchases/logger/linkfive_logger.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_verified_receipt.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class LinkFiveClient {
  final String stagingUrl = "api.staging.linkfive.io";
  final String prodUrl = "api.linkfive.io";

  LinkFiveEnvironment environment = LinkFiveEnvironment.PRODUCTION;

  String hostUrl = "api.staging.linkfive.io";
  late LinkFiveAppDataStore _appDataStore;

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
      "authorization": "Bearer ${_appDataStore.apiKey}",
      "X-Platform": _platform,
      "X-Country": _countryCode,
      "X-App-Version": await _appVersion,
      "X-User-Id": _appDataStore.userId ?? "",
      "X-Utm-Source": _appDataStore.utmSource ?? "",
      "X-Environment": _appDataStore.environment ?? ""
    };
  }

  init(LinkFiveEnvironment env, LinkFiveAppDataStore appDataStore) {
    environment = env;
    this._appDataStore = appDataStore;
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

  Future<LinkFiveVerifiedReceipt> verifyAppleReceipt(String receipt) async {
    final uri = _makeUri("api/v1/purchases/apple/verify");
    final body = {"receipt": receipt};

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);
    LinkFiveLogger.d(response.body);

    return LinkFiveVerifiedReceipt.fromJson(jsonDecode(response.body)["data"]);
  }

  Future<List<LinkFiveVerifiedReceipt>> verifyGoogleReceipt(List<GooglePlayPurchaseDetails> purchaseDetailList) async {
    final uri = _makeUri("api/v1/purchases/google/verify");

    final body = {
      "purchases": purchaseDetailList.map((purchaseDetails) => {
        "packageName": purchaseDetails.billingClientPurchase.packageName,
        "purchaseToken": purchaseDetails.billingClientPurchase.purchaseToken,
        "orderId": purchaseDetails.billingClientPurchase.orderId,
        "purchaseTime": purchaseDetails.billingClientPurchase.purchaseTime,
        "sku": purchaseDetails.billingClientPurchase.sku,
      }).toList()
    };

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);
    LinkFiveLogger.d(response.body);

    return LinkFiveVerifiedReceipt.fromJsonList(jsonDecode(response.body)["data"]);
  }

  Uri _makeUri(String path, {Map<String, List<String>>? queryParams}) {
    if (queryParams == null) {
      return Uri.https(hostUrl, path);
    }

    return Uri.https(hostUrl, path, queryParams);
  }
}

enum LinkFiveEnvironment { STAGING, PRODUCTION }
