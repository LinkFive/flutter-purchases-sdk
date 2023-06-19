import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

/// ISO 8601 conform Units
enum PeriodUnit {
  DAYS('D'),
  WEEKS('W'),
  MONTH('M'),
  YEARS('Y');

  final String isoCode;

  const PeriodUnit(this.isoCode);
}

/// The Period class holds the amounts of periodUnits. Basically 3 Months or 5 Days, 1 Year etc.
///
/// See ISO 8601 for more information
///
/// [toString] will print P30D or P3M etc.
class Period {
  final int amount;
  final PeriodUnit periodUnit;

  Period._({required this.amount, required this.periodUnit});

  /// This will parse the Google Play Response for the Period
  ///
  /// Props to Pascal for this nicely written RegExpr.
  factory Period.fromGooglePlay(String periodText) {
    if (periodText.isEmpty) {
      throw ArgumentError("PeriodText is Empty");
    }
    //
    final regex = RegExp(r'(\d+)([A-Z])');
    final match = regex.firstMatch(periodText);
    final amount = int.parse(match!.group(1)!);
    final unitString = match.group(2);

    return Period._(
        amount: amount,
        periodUnit: switch (unitString) {
          "Y" => PeriodUnit.YEARS,
          "M" => PeriodUnit.MONTH,
          "W" => PeriodUnit.WEEKS,
          "D" => PeriodUnit.DAYS,
          _ => throw UnsupportedError("Period not supported")
        });
  }

  /// Apple already splits the response to numbers and Units.
  factory Period.fromAppStore(SKProductSubscriptionPeriodWrapper subscriptionPeriod) {
    return Period._(
        amount: subscriptionPeriod.numberOfUnits,
        periodUnit: switch (subscriptionPeriod.unit) {
          SKSubscriptionPeriodUnit.year => PeriodUnit.YEARS,
          SKSubscriptionPeriodUnit.month => PeriodUnit.MONTH,
          SKSubscriptionPeriodUnit.week => PeriodUnit.WEEKS,
          SKSubscriptionPeriodUnit.day => PeriodUnit.DAYS,
        });
  }

  factory Period.fromLinkFive(String period) => Period.fromGooglePlay(period);

  @override
  String toString() {
    return 'P$amount${periodUnit.isoCode}';
  }
}
