import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:linkfive_purchases/logger/linkfive_logger.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:linkfive_purchases/models/linkfive_verified_receipt.dart';

import 'linkfive_client.dart';

class LinkFiveBillingClient {
  late LinkFiveClient _apiClient;

  init(LinkFiveClient apiClient) {
    this._apiClient = apiClient;
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
  }

  Future<List<ProductDetails>?> getPlatformSubscriptions(
      LinkFiveResponseData linkFiveResponse) async {
    if (await _isStoreReachable) {
      return await _loadProducts(linkFiveResponse.subscriptionList);
    }
    LinkFiveLogger.d("No Products to return Store is proabably not reachable");
    return null;
  }

  Future<bool> get _isStoreReachable async {
    LinkFiveLogger.d("wait for connection");
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

  Future<List<LinkFiveVerifiedReceipt>> get verifiedReceipts async {
    final isAvailable = await _isStoreReachable;

    if (!isAvailable) {
      return List.empty();
    }

    if (Platform.isIOS) {
      try {
        final receiptData = await SKReceiptManager.retrieveReceiptData();
        final verifiedReceipt =
            await _apiClient.verifyAppleReceipt(receiptData);

        if (verifiedReceipt.isExpired) {
          return List.empty();
        }

        return [verifiedReceipt];
      } catch (error) {
        LinkFiveLogger.e("An error occured: $error");
        return List.empty();
      }
    } else if (Platform.isAndroid) {
      final androidExtension = InAppPurchase.instance
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

      final pastPurchases =
          (await androidExtension.queryPastPurchases()).pastPurchases;

      // TODO: Verify receipts to get for example the expiration date!
      final verifiedReceipts = pastPurchases
          .map(
              (element) => LinkFiveVerifiedReceipt.fromPurchaseDetails(element))
          .toList();

      return verifiedReceipts;
    }

    return List.empty();
  }
}
