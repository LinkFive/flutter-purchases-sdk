import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:in_app_purchases_intl/in_app_purchases_intl.dart';
import 'package:linkfive_purchases/util/subscription_duration_convert.dart';

/// LinkFive Products to offer.
///
/// Basically a subscription you want to offer to your user.
///
/// it includes:
/// [linkFiveSkuData] includes platform specific information
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

  LinkFiveProducts(
      {this.productDetailList = const [], this.attributes, this.error});

  /// Only use this function in combination with your Paywall UI. This is a helper function
  ///
  /// Function to get the subscription Data automatically
  ///
  /// [calculateDeal] is default true. This will calculate the deal automatically
  ///
  /// The reference is always the subscription with the lowest duration
  List<SubscriptionData> paywallUIHelperData(
      {required BuildContext context, bool calculateDeal = true}) {
    // if no or just 1 subscription is shown
    // disable the deal
    if (productDetailList.length <= 1) {
      calculateDeal = false;
    }
    LinkFiveProductDetails? lowestDurationProduct = null;
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
      final durationStrings =
          linkFiveProductDetails.paywallUIHelperDurationData(context);

      /// Sub Data with Strings
      var subData = SubscriptionData(
          durationTitle: durationStrings.durationText.toTitleCase(),
          durationShort: durationStrings.durationTextNumber.toTitleCase(),
          productDetails: linkFiveProductDetails.productDetails,
          price: linkFiveProductDetails.productDetails.price,
          rawPrice: linkFiveProductDetails.productDetails.rawPrice,
          currencySymbol: linkFiveProductDetails.productDetails.currencySymbol,
          duration: SubscriptionDurationConvert.getSubscriptionDurationAsText(
              linkFiveProductDetails.duration),
          monthText: PaywallL10NHelper.of(context).month,
          index: index);
      // calculate the deal
      if (lowestDurationProduct != null) {
        if (lowestDurationProduct != linkFiveProductDetails) {
          int dealPercent = ((1 -
                      lowestDurationProduct.productDetails.rawPrice /
                          linkFiveProductDetails.productDetails.rawPrice) *
                  100)
              .round();
          subData.dealPercentage = dealPercent;
        }
      }
      // increase index
      index += 1;
      return subData;
    }).toList();
  }
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
  final ProductDetails productDetails;

  LinkFiveProductDetails(this.productDetails);

  /// Duration of the product
  ///
  /// Possible values:
  ///
  /// enum SubscriptionDuration {
  ///   P1W,
  ///   P1M,
  ///   P3M,
  ///   P6M,
  ///   P1Y,
  /// }
  SubscriptionDuration get duration {
    if (productDetails is GooglePlayProductDetails) {
      GooglePlayProductDetails googleDetails =
          productDetails as GooglePlayProductDetails;
      return SubscriptionDurationConvert.fromGoogle(
          googleDetails.skuDetails.subscriptionPeriod);
    }
    if (productDetails is AppStoreProductDetails) {
      AppStoreProductDetails iosDetails =
          productDetails as AppStoreProductDetails;
      return SubscriptionDurationConvert.fromAppStore(
          iosDetails.skProduct.subscriptionPeriod);
    }
    throw UnsupportedError("Currently there is only android and iOS supported");
  }

  /// Helper to get the Strings from the intl package
  ///
  /// Use it only with a valid context.
  DurationStrings paywallUIHelperDurationData(BuildContext context) {
    return duration.toString().split(".").last.toDurationStrings(context);
  }
}
