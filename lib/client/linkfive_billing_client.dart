import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:linkfive_purchases/models/linkfive_verified_receipt.dart';

import 'linkfive_client.dart';

/// Internal Billing Client. It holds the connection to the native billing sdk
class LinkFiveBillingClient {
  late LinkFiveClient _apiClient;

  /// Init with the LinkFive Api client
  init(LinkFiveClient apiClient) {
    this._apiClient = apiClient;
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
  }

  /// load the products from the native billing sdk
  Future<List<ProductDetails>?> getPlatformSubscriptions(
      LinkFiveResponseData linkFiveResponse) async {
    if (await _isStoreReachable) {
      return await _loadProducts(linkFiveResponse.subscriptionList);
    }
    LinkFiveLogger.d("No Products to return Store is proabably not reachable");
    return null;
  }

  /// waits for the platform connection
  Future<bool> get _isStoreReachable async {
    LinkFiveLogger.d("Is Store Reachable?");
    // check simulator
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      if (!iosInfo.isPhysicalDevice) {
        return false;
      }
    }
    // wait for connecting
    final bool available = await InAppPurchase.instance.isAvailable();

    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      LinkFiveLogger.e("Store not reachable");
      return false;
    }
    LinkFiveLogger.d("Store reachable");
    return true;
  }

  /// Load products from the native store
  Future<List<ProductDetails>> _loadProducts(
      List<LinkFiveResponseDataSubscription> subscriptionList) async {
    LinkFiveLogger.d("load products from store");
    Set<String> _kIds = subscriptionList.map((e) => e.sku).toSet();
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);

    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      LinkFiveLogger.e("ID NOT FOUND");
    }
    if (response.error != null) {
      LinkFiveLogger.e(
          "Purchase Error ${response.error?.code}, ${response.error?.message}");
    }
    return response.productDetails;
  }

  /// Fetches the active receipts and sends them to LinkFive
  Future<List<LinkFiveVerifiedReceipt>> get verifiedReceipts async {
    final isAvailable = await _isStoreReachable;

    if (!isAvailable) {
      LinkFiveLogger.e(
          "Store not reachable. Are you using an Emulator/Simulator?)");
      return List.empty();
    }
    List<LinkFiveVerifiedReceipt> linkFiveReceipts = List.empty();

    if (Platform.isIOS) {
      try {
        final receiptData = await SKReceiptManager.retrieveReceiptData();
        // print(receiptData);
        linkFiveReceipts = await _apiClient.verifyAppleReceipt(receiptData);
      } catch (error) {
        LinkFiveLogger.d("ReceiptError. Maybe just no receipt?: $error");
      }
    } else if (Platform.isAndroid) {
      // get android purchases
      final androidExtension = InAppPurchase.instance
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final pastPurchases =
          (await androidExtension.queryPastPurchases()).pastPurchases;

      if (pastPurchases.isNotEmpty) {
        // verify a list of purchases
        linkFiveReceipts = await _apiClient.verifyGoogleReceipt(pastPurchases);
      }
    }

    // filter expired subscriptions
    return linkFiveReceipts.where((element) => !element.isExpired).toList();
  }
}
