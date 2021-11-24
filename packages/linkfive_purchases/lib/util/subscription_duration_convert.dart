import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

/// Convert The duration String from Google and Apple to an actual Duration
class SubscriptionDurationConvert {
  /// Convert Google Period to Duration
  static SubscriptionDuration? fromGoogle(String period) {
    switch (period) {
      case "P1Y":
        return SubscriptionDuration.P1Y;
      case "P6M":
        return SubscriptionDuration.P6M;
      case "P3M":
        return SubscriptionDuration.P3M;
      case "P1M":
        return SubscriptionDuration.P1M;
      case "P1W":
        return SubscriptionDuration.P1W;
    }
    return null;
  }

  /// Convert Apple Period to Duration
  ///
  /// return null if not possible
  static SubscriptionDuration? fromAppStore(
      SKProductSubscriptionPeriodWrapper? subscriptionPeriod) {
    if (subscriptionPeriod == null) {
      return null;
    }
    if (subscriptionPeriod.unit == SKSubscriptionPeriodUnit.year) {
      return SubscriptionDuration.P1Y;
    }
    if (subscriptionPeriod.unit == SKSubscriptionPeriodUnit.month) {
      if (subscriptionPeriod.numberOfUnits == 6) {
        return SubscriptionDuration.P6M;
      }
      if (subscriptionPeriod.numberOfUnits == 3) {
        return SubscriptionDuration.P3M;
      }
      if (subscriptionPeriod.numberOfUnits == 1) {
        return SubscriptionDuration.P1M;
      }
    }
    if (subscriptionPeriod.unit == SKSubscriptionPeriodUnit.week) {
      return SubscriptionDuration.P1W;
    }

    return null;
  }

  /// Convert LinkFive String Period to Duration
  ///
  /// return null if not possible
  static SubscriptionDuration? fromLinkFive(String? period) {
    switch (period) {
      case "P1Y":
        return SubscriptionDuration.P1Y;
      case "P6M":
        return SubscriptionDuration.P6M;
      case "P3M":
        return SubscriptionDuration.P3M;
      case "P1M":
        return SubscriptionDuration.P1M;
      case "P1W":
        return SubscriptionDuration.P1W;
      case null:
        return null;
    }
    return null;
  }

  /// Convert from [SubscriptionDuration] to a String
  ///
  /// possible values:
  ///   "P1Y"
  ///   "P6M"
  ///   "P3M"
  ///   "P1M"
  ///   "P1W"
  static String? getSubscriptionDurationAsText(
      SubscriptionDuration? subscriptionDuration) {
    switch (subscriptionDuration) {
      case SubscriptionDuration.P1Y:
        return "P1Y";
      case SubscriptionDuration.P6M:
        return "P6M";
      case SubscriptionDuration.P3M:
        return "P3M";
      case SubscriptionDuration.P1M:
        return "P1M";
      case SubscriptionDuration.P1W:
        return "P1W";
      case null:
        return null;
    }
  }
}
