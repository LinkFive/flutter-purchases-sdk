import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

class LinkFiveBillingClient {
  init() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
  }

  Future<List<ProductDetails>?> getPlatformSubscriptions(LinkFiveResponseData linkFiveResponse) async {
    if (await _checkStoreReachable()) {
      return await _loadProducts(linkFiveResponse.subscriptionList);
    }
    print("No Products to return Store is proabably not reachable");
    return null;
  }

  _checkStoreReachable() async {
    print("wait for connection");
    // wait for connecting
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      print("Store not reachable");
      return false;
    }
    print("Store reachable");
    return true;
  }

  Future<List<ProductDetails>> _loadProducts(List<LinkFiveResponseDataSubscription> subscriptionList) async {
    print("load products from store");
    Set<String> _kIds = subscriptionList.map((e) => e.sku).toSet();
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);

    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      print("ID NOT FOUND");
    }
    if (response.error != null) {
      print("Purchase Error ${response.error?.code}, ${response.error?.message}");
    }
    return response.productDetails;
  }

  Future<List<PurchaseDetails>> loadPurchasedProducts() async {
    await _checkStoreReachable();
    if(Platform.isAndroid){
      var androidExtension = InAppPurchase.instance.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      var pastPurchasesQuery = await androidExtension.queryPastPurchases();
      return pastPurchasesQuery.pastPurchases;
    }
    return List.empty();
  }
}
