import 'package:linkfive_purchases/linkfive_purchases.dart';

/// Verified Receipt from LinkFive including all data
@deprecated
class LinkFiveVerifiedReceipt {
  LinkFiveVerifiedReceipt(
      {required this.sku,
      this.purchaseId,
      required this.transactionDate,
      this.validUntilDate,
      this.isTrial,
      required this.isExpired,
      this.familyName,
      this.attributes,
      this.period});

  /// Also called productID
  String sku;
  String? purchaseId;
  DateTime transactionDate;
  DateTime? validUntilDate;
  bool? isTrial;
  bool isExpired;
  String? familyName;
  String? attributes;
  String? period;

  factory LinkFiveVerifiedReceipt.fromJson(Map<String, dynamic> json) =>
      LinkFiveVerifiedReceipt(
          sku: json["sku"],
          purchaseId: json["purchaseId"],
          transactionDate: DateTime.parse(json["transactionDate"]),
          validUntilDate: DateTime.parse(json["validUntilDate"]),
          isTrial: json["isTrial"],
          isExpired: json["isExpired"],
          familyName: json["familyName"],
          attributes: json["attributes"],
          period: json["period"]);

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "purchaseId": purchaseId,
        "transactionDate": transactionDate,
        "validUntilDate": validUntilDate,
        "isTrial": isTrial,
        "isExpired": isExpired,
        "familyName": familyName,
        "attributes": attributes,
        "period": period,
      };

  static List<LinkFiveVerifiedReceipt> fromJsonList(
          Map<String, dynamic> json) =>
      (json["purchases"] as List)
          .map((e) => LinkFiveVerifiedReceipt.fromJson(e))
          .toList();

  /// Duration Period of the subscription
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
  SubscriptionDuration? get subscriptionDuration =>
      SubscriptionDurationConvert.fromLinkFive(period);
}
