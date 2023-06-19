import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:linkfive_purchases/models/period.dart';
import 'package:linkfive_purchases/models/recurrence.dart';

/// A Product Phase represents a pricing interval.
class PricingPhase {
  final PricingPhaseWrapper? googlePlayObj;
  final SKProductWrapper? appStoreObj;

  PricingPhase._({this.googlePlayObj, this.appStoreObj});

  /// Represents a pricing phase, describing how a user pays at a point in time.
  int get billingCycleCount {
    if (googlePlayObj != null) {
      return googlePlayObj!.billingCycleCount;
    }
    if (appStoreObj != null) {
      return 1;
    }
    throw UnsupportedError("Store not supported");
  }

  /// Billing period for which the given price applies, specified in ISO 8601
  /// format.
  Period get billingPeriod {
    if (googlePlayObj != null) {
      return Period.fromGooglePlay(googlePlayObj!.billingPeriod);
    }
    if (appStoreObj != null) {
      return Period.fromAppStore(appStoreObj!.subscriptionPeriod!);
    }
    throw UnsupportedError("Store not supported");
  }

  /// Returns formatted price for the payment cycle, including its currency
  /// sign.
  String get formattedPrice {
    if (googlePlayObj != null) {
      return googlePlayObj!.formattedPrice;
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
      return googlePlayObj!.priceAmountMicros;
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
      return googlePlayObj!.priceCurrencyCode;
    }
    if (appStoreObj != null) {
      return appStoreObj!.priceLocale.currencyCode;
    }
    throw UnsupportedError("Store not supported");
  }

  /// Recurrence of the phase
  Recurrence get recurrence {
    if (googlePlayObj != null) {
      return switch (googlePlayObj!.recurrenceMode) {
        RecurrenceMode.finiteRecurring => Recurrence.finiteRecurring,
        RecurrenceMode.infiniteRecurring => Recurrence.infiniteRecurring,
        RecurrenceMode.nonRecurring => Recurrence.nonRecurring,
      };
    }
    if (appStoreObj != null) {
      return Recurrence.infiniteRecurring;
    }
    throw UnsupportedError("Store not supported");
  }

  factory PricingPhase.fromGooglePlay(PricingPhaseWrapper phaseWrapper) => PricingPhase._(googlePlayObj: phaseWrapper);

  factory PricingPhase.fromAppStore(SKProductWrapper skProductWrapper) => PricingPhase._(appStoreObj: skProductWrapper);
}
