import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:linkfive_purchases/util/currency_symbol.dart';

/// The Price of a one time purchase.
class OneTimePurchasePrice {
  final GooglePlayProductDetails? googlePlayObj;
  final SKProductWrapper? appStoreObj;

  OneTimePurchasePrice._({this.googlePlayObj, this.appStoreObj});

  /// Returns formatted price for the payment cycle, including its currency
  /// sign.
  String get formattedPrice {
    if (googlePlayObj != null) {
      return googlePlayObj!.price;
    }
    if (appStoreObj != null) {
      return appStoreObj!.price;
    }
    throw UnsupportedError("Store not supported");
  }

  /// Returns the price for the payment cycle in micro-units, where 1,000,000
  /// micro-units equal one unit of the currency.
  int get priceAmountMicros {
    if (googlePlayObj != null) {
      return googlePlayObj!.productDetails.oneTimePurchaseOfferDetails!.priceAmountMicros;
    }
    if (appStoreObj != null) {
      return (double.parse(appStoreObj!.price) * 1000000).toInt();
    }
    throw UnsupportedError("Store not supported");
  }

  /// ISO 4217
  ///
  /// e.g. EUR, USD
  String get priceCurrencyCode {
    if (googlePlayObj != null) {
      return googlePlayObj!.productDetails.oneTimePurchaseOfferDetails!.priceCurrencyCode;
    }
    if (appStoreObj != null) {
      return appStoreObj!.priceLocale.currencyCode;
    }
    throw UnsupportedError("Store not supported");
  }

  /// Currency symbol such as $ or €
  String get priceCurrencySymbol {
    if (googlePlayObj != null) {
      if (googlePlayObj!.currencySymbol.isEmpty) {
        return getCurrencySymbol(googlePlayObj!.currencyCode);
      }
      return googlePlayObj!.currencySymbol;
    }
    if (appStoreObj != null) {
      if(appStoreObj!.priceLocale.currencySymbol.isEmpty){
        return getCurrencySymbol(appStoreObj!.priceLocale.currencyCode);
      }
      return appStoreObj!.priceLocale.currencySymbol;
    }
    throw UnsupportedError("Store not supported");
  }

  factory OneTimePurchasePrice.fromGooglePlay(GooglePlayProductDetails googlePlayProductDetails) =>
      OneTimePurchasePrice._(googlePlayObj: googlePlayProductDetails);

  factory OneTimePurchasePrice.fromAppStore(SKProductWrapper skProductWrapper) =>
      OneTimePurchasePrice._(appStoreObj: skProductWrapper);
}
