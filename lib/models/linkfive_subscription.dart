import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:in_app_purchases_intl/in_app_purchases_intl.dart';
import 'package:linkfive_purchases/purchases.dart';

/// LinkFive SubscriotionData. it includes:
/// [linkFiveSkuData] includes platform specific information
/// [attributes] which are comming from the server
/// [error] if something is off.
class LinkFiveSubscriptionData {
  /// Sku Data enhances with LinkFive
  final List<LinkFiveProductDetails> linkFiveSkuData;

  /// Attributes coming from the playout
  final String? attributes;

  /// error string
  final String? error;

  LinkFiveSubscriptionData(this.linkFiveSkuData, this.attributes, this.error);

  /// Function to get the subscription Data automatically
  /// [calculateDeal] is default true. This will calculate the deal automatically
  /// The reference is always the subscription with the lowest duration
  List<SubscriptionData> getSubscriptionData(
      {required BuildContext context, bool calculateDeal = true}) {
    // if no or just 1 subscription is shown
    // disable the deal
    if (linkFiveSkuData.length <= 1) {
      calculateDeal = false;
    }
    LinkFiveProductDetails? lowestDurationProduct = null;
    if (calculateDeal) {
      // get the lowest duration
      lowestDurationProduct = linkFiveSkuData.reduce((curr, next) {
        final currDuration = curr.getSubscriptionPeriod();
        final nextDuration = next.getSubscriptionPeriod();
        if (currDuration == null || nextDuration == null) {
          return curr;
        }
        return currDuration.index < nextDuration.index ? curr : next;
      });
    }
    // Map through everything and calculate the deal if set to true
    return linkFiveSkuData.map((linkFiveProductDetails) {
      final durationStrings =
          linkFiveProductDetails.getDurationStrings(context);

      /// Sub Data with Strings
      var subData = SubscriptionData(
          price: linkFiveProductDetails.productDetails.price,
          durationTitle: durationStrings.durationText.toTitleCase(),
          durationShort: durationStrings.durationTextNumber.toTitleCase(),
          productDetails: linkFiveProductDetails.productDetails);
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
      return subData;
    }).toList();
  }
}

/// LinkFive class with platform [ProductDetails] e.g. Price
class LinkFiveProductDetails {
  final ProductDetails productDetails;

  LinkFiveProductDetails(this.productDetails);

  /// Duration Period of the subscription
  SubscriptionDuration? getSubscriptionPeriod() {
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
    return null;
  }

  /// Helper to get the Strings from the intl package
  DurationStrings getDurationStrings(BuildContext context) {
    final period = getSubscriptionPeriod();
    return period.toString().split(".").last.toDurationStrings(context);
  }
}
