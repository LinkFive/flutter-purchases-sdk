import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:linkfive_purchases/client/linkfive_client_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/logic/linkfive_user_management.dart';
import 'package:linkfive_purchases/models/requests/purchase_request_google.dart';
import 'package:linkfive_purchases/models/requests/purchase_request_google_otp.dart';
import 'package:linkfive_purchases/models/requests/purchase_request_pricing_phase.dart';
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
  Future<LinkFiveActiveProducts> purchaseIos({
    required AppStoreProductDetails? productDetails,
    required AppStorePurchaseDetails purchaseDetails,
  }) async {
    final uri = _makeUri("api/v1/purchases/user/apple");

    final transaction = purchaseDetails.skPaymentTransaction;
    final transactionId = transaction.transactionIdentifier ?? "";
    final body = {
      "currency": productDetails?.currencyCode,
      "price": productDetails?.rawPrice,
      "transactionId": transactionId,
      "originalTransactionId": transaction.originalTransaction?.transactionIdentifier ?? transactionId
    };

    LinkFiveLogger.d("purchase. $body");
    try {
      final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);

      return _parseOneTimePurchaseListResponse(response);
    } catch (e) {
      LinkFiveLogger.e("Purchase Request Error: ${e.toString()}");
      LinkFiveLogger.e("Try Again with same request");

      final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);

      return _parseOneTimePurchaseListResponse(response);
    }
  }

  /// after a purchase on Google we call the purchases/google
  /// We don't need to do this on Android
  @override
  Future<LinkFiveActiveProducts> purchaseGooglePlay(
      GooglePlayPurchaseDetails purchaseDetails, GooglePlayProductDetails productDetails) async {
    final uri = _makeUri("api/v1/purchases/user/google");

    String? basePlanId;
    List<PricingPhase> pricingPhaseList = [];
    final subscriptionIndex = productDetails.subscriptionIndex;
    final offerDetailList = productDetails.productDetails.subscriptionOfferDetails;
    if (subscriptionIndex != null && offerDetailList != null && offerDetailList.isNotEmpty) {
      final offerDetail = offerDetailList[subscriptionIndex];
      basePlanId = offerDetail.basePlanId;
      for (final pricingPhase in offerDetail.pricingPhases) {
        pricingPhaseList.add(PricingPhase.fromGooglePlay(pricingPhase));
      }
    }

    final purchaseBody = PurchaseRequestGoogle(
        sku: purchaseDetails.productID,
        purchaseId: purchaseDetails.billingClientPurchase.orderId,
        purchaseToken: purchaseDetails.billingClientPurchase.purchaseToken,
        basePlanId: basePlanId,
        purchaseRequestPricingPhaseList: [
          for (final phase in pricingPhaseList) PurchaseRequestPricingPhase.fromPricingPhase(phase)
        ]);

    LinkFiveLogger.d("purchase: $purchaseBody");

    try {
      final response = await http.post(uri, body: jsonEncode(purchaseBody.toJson()), headers: await _headers);

      return _parseOneTimePurchaseListResponse(response);
    } catch (e) {
      LinkFiveLogger.e("Purchase Request Error: ${e.toString()}");
      LinkFiveLogger.e("Try Again with same request");

      final response = await http.post(uri, body: jsonEncode(purchaseBody.toJson()), headers: await _headers);

      return _parseOneTimePurchaseListResponse(response);
    }
  }

  @override
  Future<LinkFiveActiveProducts> purchaseGooglePlayOneTimePurchase(
      GooglePlayPurchaseDetails purchaseDetails, OneTimePurchaseOfferDetailsWrapper otpDetails) async {
    final uri = _makeUri("api/v1/purchases/user/google/one-time-purchase");
    final purchaseBody = PurchaseRequestOneTimePurchaseGoogle(
      productId: purchaseDetails.productID,
      purchaseToken: purchaseDetails.billingClientPurchase.purchaseToken,
      orderId: purchaseDetails.billingClientPurchase.orderId,
      priceAmountMicros: otpDetails.priceAmountMicros,
      priceCurrencyCode: otpDetails.priceCurrencyCode,
    );

    LinkFiveLogger.d("purchase: $purchaseBody");
    try {
      final response = await http.post(uri, body: jsonEncode(purchaseBody.toJson()), headers: await _headers);

      return _parseOneTimePurchaseListResponse(response);
    } catch (e) {
      LinkFiveLogger.e("Purchase Request Error: ${e.toString()}");
      LinkFiveLogger.e("Try Again with same request");

      final response = await http.post(uri, body: jsonEncode(purchaseBody.toJson()), headers: await _headers);

      return _parseOneTimePurchaseListResponse(response);
    }
  }

  /// Fetches the receipts for a user
  ///
  /// if no LinkFive UUID is provided, LinkFive will generate a new user ID
  ///
  @override
  Future<LinkFiveActiveProducts> fetchUserPlanListFromLinkFive() async {
    final uri = _makeUri("api/v1/purchases/user");

    final response = await http.get(uri, headers: await _headers);
    return _parseOneTimePurchaseListResponse(response);
  }

  /// RESTORE APPLE APP STORE
  ///
  /// This will send all restored transactionIds to LinkFive
  /// We will check against apple if those transaction are valid and
  /// enable or disable a product
  @override
  Future<LinkFiveActiveProducts> restoreIos(List<LinkFiveRestoreAppleItem> restoreList) async {
    final uri = _makeUri("api/v1/purchases/user/apple/restore");

    final body = {
      "transactionIdList": restoreList.map((restoreAppleItem) {
        return restoreAppleItem.toMap;
      }).toList(growable: false)
    };

    LinkFiveLogger.d("Restore body: $body");

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);
    return _parseOneTimePurchaseListResponse(response);
  }

  /// RESTORE GOOGLE PLAY STORE
  ///
  /// This will send all restored transactionIds to LinkFive
  /// We will check against apple if those transaction are valid and
  /// enable or disable a product
  @override
  Future<LinkFiveActiveProducts> restoreGoogle(List<LinkFiveRestoreGoogleItem> restoreList) async {
    final uri = _makeUri("api/v1/purchases/user/google/restore");

    final body = {
      "restoreList": restoreList.map((restoreGoogleItem) {
        return restoreGoogleItem.toMap;
      }).toList(growable: false)
    };

    LinkFiveLogger.d("Restore body: $body");

    final response = await http.post(uri, body: jsonEncode(body), headers: await _headers);
    return _parseOneTimePurchaseListResponse(response);
  }

  @override
  Future<LinkFiveActiveProducts> changeUserId(String? userId) async {
    final uri = _makeUri("api/v1/purchases/user/customer-user-id");

    final response = await http.put(uri, headers: await _headers);
    return _parseOneTimePurchaseListResponse(response);
  }

  /// Get LinkFive URI with path Parameters
  Uri _makeUri(String path, {Map<String, List<String>>? queryParams}) {
    if (queryParams == null) {
      return Uri.https(hostUrl, path);
    }

    return Uri.https(hostUrl, path, queryParams);
  }

  LinkFiveActiveProducts _parseOneTimePurchaseListResponse(http.Response response) {
    LinkFiveLogger.d("Parse with body ${response.body}");

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Save the LinkFive userID if any exists
    LinkFiveUserManagement().onResponse(jsonResponse);

    return LinkFiveActiveProducts.fromJson(jsonResponse["data"]);
  }
}
