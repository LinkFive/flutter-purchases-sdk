import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';

/// Internal Billing Client. It holds the connection to the native billing sdk
class LinkFiveBillingClientTest extends LinkFiveBillingClientInterface {
  /// TEST MODE
  Future<List<ProductDetails>?> getPlatformSubscriptions(
      LinkFiveResponseData linkFiveResponse) async {
    return _loadProducts();
  }

  /// TEST MODE
  List<ProductDetails> _loadProducts() {
    LinkFiveLogger.d("TEST: load products from store");
    if (Platform.isAndroid) {
      return [1, 2]
          .map((number) => GooglePlayProductDetails.fromSkuDetails(
              SkuDetailsWrapper(
                  description: "Test Descriptiption $number",
                  freeTrialPeriod: "P7D",
                  introductoryPrice: "$number.99",
                  introductoryPriceCycles: 1,
                  introductoryPricePeriod: "",
                  price: "$number.99",
                  priceAmountMicros: number * 1000000 + 990000,
                  priceCurrencyCode: "EUR",
                  priceCurrencySymbol: "€",
                  sku: "test_$number",
                  subscriptionPeriod: number == 1 ? "P1M": "P1Y",
                  title: "Test title $number",
                  type: SkuType.subs,
                  originalPrice: "$number.99",
                  originalPriceAmountMicros: 1)))
          .toList(growable: false);
    } else if (Platform.isIOS) {
      return [1, 2]
          .map((number) => AppStoreProductDetails.fromSKProduct(
                SKProductWrapper(
                    productIdentifier: "test_$number",
                    localizedTitle: "Test title $number",
                    localizedDescription: "Test Descriptiption $number",
                    priceLocale: SKPriceLocaleWrapper(
                        currencyCode: "EUR",
                        currencySymbol: "€",
                        countryCode: "DE"),
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
