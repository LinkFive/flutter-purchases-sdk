import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:linkfive_purchases/client/linkfive_client_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/logic/linkfive_user_management.dart';
import 'package:linkfive_purchases/models/linkfive_restore_apple_item.dart';
import 'package:linkfive_purchases/models/linkfive_restore_google_item.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// HTTP client to LinkFive
class LinkFiveClient extends LinkFiveClientInterface {
  final String stagingUrl = "api.staging.linkfive.io";
  final String prodUrl = "api.linkfive.io";

  /// current Environment of [LinkFiveEnvironment]
  LinkFiveEnvironment environment = LinkFiveEnvironment.PRODUCTION;

  /// current Host. this will set in init
  String hostUrl = "api.linkfive.io";
  late LinkFiveAppDataStore _appDataStore;

  /// current plattform
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
    return PlatformDispatcher.instance.locale.countryCode ?? "";
  }

  Future<String> get _appVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// all kind of headers for LinkFive Requests
  Future<Map<String, String>> get _headers async {
    return {
      "Content-Type": "application/json",
      "authorization": "Bearer ${_appDataStore.apiKey}",
      "X-Platform": _platform,
      "X-Country": _countryCode,
      "X-App-Version": await _appVersion,
      "X-User-Id": _appDataStore.userId ?? "",
      "X-LinkFive-UUID": LinkFiveUserManagement().linkFiveUUID ?? "",
      "X-Utm-Source": _appDataStore.utmSource ?? "",
      "X-Environment": _appDataStore.environment ?? "",
      "X-LinkFive-Version": "FL-${LinkFivePurchases.VERSION}"
    };
  }

  /// Mandatory init with [LinkFiveEnvironment] and [LinkFiveAppDataStore]
  @override
  init(LinkFiveEnvironment env, LinkFiveAppDataStore appDataStore) {
    environment = env;
    _appDataStore = appDataStore;
    if (env == LinkFiveEnvironment.STAGING) {
      hostUrl = stagingUrl;
    } else {
      hostUrl = prodUrl;
    }
  }

  /// Call to LinkFive to get the subscriptions to show
  @override
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

  /// after a purchase on ios we call the purchases/apple
  /// We don't need to do this on Android
  @override
  Future<List<LinkFivePlan>> purchaseIos(
      AppStoreProductDetails productDetails, AppStorePurchaseDetails purchaseDetails) async {
    final uri = _makeUri("api/v1/purchases/user/apple");

    final transaction = purchaseDetails.skPaymentTransaction;

    var transactionDate = DateTime.now();
    if (purchaseDetails.transactionDate != null) {
      transactionDate = DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate!));
    }
    final transactionId = transaction.transactionIdentifier ?? "";
    final body = {
      "sku": productDetails.id,
      "currency": productDetails.currencyCode,
      "country": productDetails.skProduct.priceLocale.countryCode,
      "price": productDetails.rawPrice,
      "purchaseDate": transactionDate.toIso8601String(),
      "transactionId": transactionId,
      "originalTransactionId": transaction.originalTransaction?.transactionIdentifier ?? transactionId
    };

    LinkFiveLogger.d("purchase. $body");

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);

    return _parsePlanListResponse(response);
  }

  /// after a purchase on Google we call the purchases/google
  /// We don't need to do this on Android
  @override
  Future<List<LinkFivePlan>> purchaseGooglePlay(GooglePlayPurchaseDetails purchaseDetails) async {
    final uri = _makeUri("api/v1/purchases/user/google");

    final purchaseId = purchaseDetails.billingClientPurchase.orderId;
    final productId = purchaseDetails.productID;
    final purchaseToken = purchaseDetails.billingClientPurchase.purchaseToken;

    final body = {"sku": productId, "purchaseId": purchaseId, "purchaseToken": purchaseToken};
    LinkFiveLogger.d("purchase: $body");

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);

    return _parsePlanListResponse(response);
  }

  /// Fetches the receipts for a user
  ///
  /// if no LinkFive UUID is provided, LinkFive will generate a new user ID
  ///
  @override
  Future<List<LinkFivePlan>> fetchUserPlanListFromLinkFive() async {
    final uri = _makeUri("api/v1/purchases/user");

    final response = await http.get(uri, headers: await _headers);
    return _parsePlanListResponse(response);
  }

  /// RESTORE APPLE APP STORE
  ///
  /// This will send all restored transactionIds to LinkFive
  /// We will check against apple if those transaction are valid and
  /// enable or disable a product
  @override
  Future<List<LinkFivePlan>> restoreIos(List<LinkFiveRestoreAppleItem> restoreList) async {
    final uri = _makeUri("api/v1/purchases/user/apple/restore");

    final body = {
      "transactionIdList": restoreList.map((restoreAppleItem) {
        return restoreAppleItem.toMap;
      }).toList(growable: false)
    };

    LinkFiveLogger.d("Restore body: $body");

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);
    return _parsePlanListResponse(response);
  }

  /// RESTORE GOOGLE PLAY STORE
  ///
  /// This will send all restored transactionIds to LinkFive
  /// We will check against apple if those transaction are valid and
  /// enable or disable a product
  @override
  Future<List<LinkFivePlan>> restoreGoogle(List<LinkFiveRestoreGoogleItem> restoreList) async {
    final uri = _makeUri("api/v1/purchases/user/google/restore");

    final body = {
      "restoreList": restoreList.map((restoreGoogleItem) {
        return restoreGoogleItem.toMap;
      }).toList(growable: false)
    };

    LinkFiveLogger.d("Restore body: $body");

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);
    return _parsePlanListResponse(response);
  }

  @override
  Future<List<LinkFivePlan>> changeUserId(String? userId) async {
    final uri = _makeUri("api/v1/purchases/user/customer-user-id");

    final response = await http.put(uri, headers: await _headers);
    return _parsePlanListResponse(response);
  }

  /// Get LinkFive URI with path Parameters
  Uri _makeUri(String path, {Map<String, List<String>>? queryParams}) {
    if (queryParams == null) {
      return Uri.https(hostUrl, path);
    }

    return Uri.https(hostUrl, path, queryParams);
  }

  List<LinkFivePlan> _parsePlanListResponse(http.Response response) {
    LinkFiveLogger.d("Parse plan with body ${response.body}");

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Save the LinkFive userID if any exists
    LinkFiveUserManagement().onResponse(jsonResponse);

    return LinkFivePlan.fromJsonList(jsonResponse["data"]);
  }
}
