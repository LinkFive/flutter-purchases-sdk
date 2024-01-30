import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:linkfive_purchases/models/one_time_purchase_price.dart';
import 'package:linkfive_purchases/models/pricing_phase.dart';
import 'package:linkfive_purchases/models/product_type.dart';

/// LinkFive Products to offer.
///
/// Basically a subscription you want to offer to your user.
///
/// it includes:
/// [productDetailList] includes platform specific information
/// [attributes] which are comming from the server
/// [error] if something has an error.
class LinkFiveProducts {
  /// All Available Products
  ///
  /// The data is enhances with Additional data like product Groups and custom data
  ///
  final List<LinkFiveProductDetails> productDetailList;

  /// Attributes coming from the subscription playout
  ///
  /// These Attributes are base64 encoded. please decode.
  final String? attributes;

  /// error string
  final String? error;

  LinkFiveProducts({this.productDetailList = const [], this.attributes, this.error});

/* Deprecated due to change of Google subscriptions
  /// Only use this function in combination with your Paywall UI. This is a helper function
  ///
  /// Function to get the subscription Data automatically
  ///
  /// [calculateDeal] is default true. This will calculate the deal automatically
  ///
  /// The reference is always the subscription with the lowest duration
  List<SubscriptionData> paywallUIHelperData({required BuildContext context, bool calculateDeal = true}) {
    // if no or just 1 subscription is shown
    // disable the deal
    if (productDetailList.length <= 1) {
      calculateDeal = false;
    }
    LinkFiveProductDetails? lowestDurationProduct;
    if (calculateDeal) {
      // get the lowest duration
      lowestDurationProduct = productDetailList.reduce((curr, next) {
        final currDuration = curr.duration;
        final nextDuration = next.duration;
        return currDuration.index < nextDuration.index ? curr : next;
      });
    }
    // index used to place the items
    int index = 0;

    // Map through everything and calculate the deal if set to true
    return productDetailList.map((linkFiveProductDetails) {
      final durationStrings = linkFiveProductDetails.paywallUIHelperDurationData(context);

      /// Sub Data with Strings
      var subData = SubscriptionData(
          durationTitle: durationStrings.durationText.toTitleCase(),
          durationShort: durationStrings.durationTextNumber.toTitleCase(),
          productDetails: linkFiveProductDetails.productDetails,
          price: linkFiveProductDetails.productDetails.price,
          rawPrice: linkFiveProductDetails.productDetails.rawPrice,
          currencySymbol: linkFiveProductDetails.productDetails.currencySymbol,
          duration: SubscriptionDurationConvert.getSubscriptionDurationAsText(linkFiveProductDetails.duration),
          monthText: PaywallL10NHelper.of(context).month,
          index: index);
      // calculate the deal
      if (lowestDurationProduct != null) {
        if (lowestDurationProduct != linkFiveProductDetails) {
          int dealPercent =
              ((1 - lowestDurationProduct.productDetails.rawPrice / linkFiveProductDetails.productDetails.rawPrice) *
                      100)
                  .round();
          subData.dealPercentage = dealPercent;
        }
      }
      // increase index
      index += 1;
      return subData;
    }).toList();
  }*/
}

/// LinkFive class with platform specific information
///
/// [ProductDetails] contains for example
///   price,
///   description,
///   currency
///
/// You can get more information if you cast ProductDetails to
///   GooglePlayProductDetails
///   or
///   AppStoreProductDetails
class LinkFiveProductDetails {
  /// Platform dependent Product Details such as GooglePlayProductDetails or AppStoreProductDetails
  final ProductDetails productDetails;

  /// Base64 encoded attributes you can send with your subscription
  final String? attributes;

  LinkFiveProductDetails(this.productDetails, {this.attributes});

  /// Returns either a [LinkFiveProductType.Subscription] or [LinkFiveProductType.OneTimePurchase]
  /// for the current product Details
  LinkFiveProductType get productType {
    if (productDetails is GooglePlayProductDetails) {
      if (googlePlayProductDetails.productDetails.oneTimePurchaseOfferDetails != null) {
        return LinkFiveProductType.OneTimePurchase;
      } else if (googlePlayProductDetails.productDetails.subscriptionOfferDetails != null) {
        return LinkFiveProductType.Subscription;
      }
    }
    throw UnsupportedError("Store not supported");
  }

  /// Converts the new Google Play Model to a known list of pricing phases
  ///
  /// on apple it does the same.
  List<PricingPhase> get pricingPhases {
    if (productDetails is GooglePlayProductDetails) {
      return [for (final phaseWrapper in googlePlayPricingPhases) PricingPhase.fromGooglePlay(phaseWrapper)];
    }
    if (productDetails is AppStoreProductDetails) {
      return [PricingPhase.fromAppStore(appStoreProductDetails.skProduct)];
    }
    throw UnsupportedError("Store not supported");
  }

  OneTimePurchasePrice get oneTimePurchasePrice {
    if (productDetails is GooglePlayProductDetails) {
      return OneTimePurchasePrice.fromGooglePlay(googlePlayProductDetails);
    }
    throw UnsupportedError("Store not supported");
  }

  /// Make sure to check for the platform before calling this getter
  GooglePlayProductDetails get googlePlayProductDetails {
    assert(productDetails is GooglePlayProductDetails);
    return productDetails as GooglePlayProductDetails;
  }

  /// Make sure to check for the platform before calling this getter
  List<PricingPhaseWrapper> get googlePlayPricingPhases {
    assert(productDetails is GooglePlayProductDetails);
    final subIndex = (productDetails as GooglePlayProductDetails).subscriptionIndex;
    if (subIndex == null) {
      return [];
    }
    return (productDetails as GooglePlayProductDetails)
        .productDetails
        .subscriptionOfferDetails![subIndex]
        .pricingPhases;
  }

  /// Make sure to check for the platform before calling this getter
  AppStoreProductDetails get appStoreProductDetails {
    assert(productDetails is AppStoreProductDetails);
    return productDetails as AppStoreProductDetails;
  }
}
