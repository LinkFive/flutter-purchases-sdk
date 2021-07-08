import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:linkfive_purchases/logger/linkfive_logger.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

class LinkFiveBillingClient {
  init() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
  }

  Future<List<ProductDetails>?> getPlatformSubscriptions(
      LinkFiveResponseData linkFiveResponse) async {
    if (await _checkStoreReachable()) {
      return await _loadProducts(linkFiveResponse.subscriptionList);
    }
    LinkFiveLogger.d("No Products to return Store is proabably not reachable");
    return null;
  }

  _checkStoreReachable() async {
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

  Future<List<PurchaseDetails>> loadPurchasedProducts() async {
    await _checkStoreReachable();
    if (Platform.isAndroid) {
      var androidExtension = InAppPurchase.instance
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      var pastPurchasesQuery = await androidExtension.queryPastPurchases();
      return pastPurchasesQuery.pastPurchases;
    } else if (Platform.isIOS) {}
    return List.empty();
  }
}
