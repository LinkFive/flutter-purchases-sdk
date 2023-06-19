import 'dart:io';

import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

/// Internal Billing Client. It holds the connection to the native billing sdk
class LinkFiveBillingClientTest extends LinkFiveBillingClientInterface {
  /// TEST MODE
  @override
  Future<List<ProductDetails>?> getPlatformSubscriptions(LinkFiveResponseData linkFiveResponse) async {
    return _loadProducts();
  }

  /// TEST MODE
  List<ProductDetails> _loadProducts() {
    LinkFiveLogger.d("TEST: load products from store");
    if (Platform.isAndroid) {
      final productList = [1, 2]
          .map((number) =>
              // ignore: invalid_use_of_visible_for_testing_member
              GooglePlayProductDetails.fromProductDetails(ProductDetailsWrapper(
                  description: "Test Descriptiption $number",
                  name: "Test title $number",
                  productId: "test_$number",
                  productType: ProductType.subs,
                  title: "Test title $number")))
          .toList(growable: false);
      return [for (final list in productList) ...list];
    } else if (Platform.isIOS) {
      return [1, 2]
          .map((number) => AppStoreProductDetails.fromSKProduct(
                SKProductWrapper(
                    productIdentifier: "test_$number",
                    localizedTitle: "Test title $number",
                    localizedDescription: "Test Descriptiption $number",
                    priceLocale: SKPriceLocaleWrapper(currencyCode: "EUR", currencySymbol: "€", countryCode: "DE"),
                    price: "$number.99",
                    subscriptionPeriod: SKProductSubscriptionPeriodWrapper(
                        numberOfUnits: 1,
                        unit: number == 1 ? SKSubscriptionPeriodUnit.month : SKSubscriptionPeriodUnit.year)),
              ))
          .toList(growable: false);
    }
    throw UnsupportedError("Currently there is only android and iOS supported");
  }
}
