import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class AppStoreProductDetailsWrapper {
  AppStoreProductDetails fromProductDetails(ProductDetails productDetails) =>
      AppStoreProductDetails(
          id: productDetails.id,
          title: productDetails.title,
          description: productDetails.description,
          price: productDetails.price,
          rawPrice: productDetails.rawPrice,
          currencyCode: productDetails.currencyCode,
          skProduct: SKProductWrapper(
            productIdentifier: productDetails.id,
            localizedTitle: productDetails.title,
            localizedDescription: productDetails.description,
            priceLocale: SKPriceLocaleWrapper(
                currencySymbol: productDetails.currencySymbol,
                currencyCode: productDetails.currencyCode,
                countryCode: 'en'),
            price: productDetails.price,
          ),
          currencySymbol: productDetails.currencySymbol);
}
