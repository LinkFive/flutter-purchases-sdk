import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client_interface.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';

/// Internal Billing Client. It holds the connection to the native billing sdk
class LinkFiveBillingClient extends LinkFiveBillingClientInterface {
  /// load the products from the native billing sdk
  @override
  Future<List<ProductDetails>?> getPlatformProducts(LinkFiveResponseData linkFiveResponse) async {
    if (await _isStoreReachable) {
      return await _loadProducts(
        subscriptionList: linkFiveResponse.subscriptionList,
        oneTimePurchaseList: linkFiveResponse.oneTimePurchaseList,
      );
    }
    LinkFiveLogger.d("No Products to return Store is probably not reachable");
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
        LinkFiveLogger.e("No PhysicalDevice detected. Please use a real device to use LinkFive");
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
  Future<List<ProductDetails>> _loadProducts({
    required List<LinkFiveResponseDataSubscription> subscriptionList,
    required List<LinkFiveResponseDataOneTimePurchase> oneTimePurchaseList,
  }) async {
    LinkFiveLogger.d("load products from store");
    final allProductIds = [
      for (final sub in subscriptionList) sub.sku,
      for (final otp in oneTimePurchaseList) otp.productId,
    ];
    final Set<String> kIds = allProductIds.toSet();
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(kIds);

    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      LinkFiveLogger.e("LinkFive tried to load the product Ids from the store but it "
          "seems some were not found: ${response.notFoundIDs.join(",")}. "
          "Are you using the correct package name or Id? If you created the subscriptions just now, it will take "
          "sometimes some time to appear through the official google or apple sdk. "
          "On Android, register your account as a licence tester: https://developer.android.com/google/play/billing/test .");
    }
    if (response.error != null) {
      LinkFiveLogger.e("Purchase Error ${response.error?.code}, ${response.error?.message}");
    }
    return response.productDetails;
  }
}
