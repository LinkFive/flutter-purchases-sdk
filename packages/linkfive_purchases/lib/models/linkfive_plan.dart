import 'package:linkfive_purchases/models/period.dart';

/// Verified Receipt from LinkFive including all data
class LinkFivePlan {
  LinkFivePlan(
      {required this.productId,
      required this.planId,
      required this.rootId,
      required this.purchaseDate,
      required this.endDate,
      required this.storeType,
      this.customerUserId,
      this.isTrial,
      this.familyName,
      this.attributes,
      this.duration});

  /// Also called productID
  String productId;
  String planId;
  String rootId;
  DateTime purchaseDate;
  DateTime endDate;
  String storeType;
  String? customerUserId;
  bool? isTrial;
  String? familyName;
  String? attributes;
  String? duration;

  factory LinkFivePlan.fromJson(Map<String, dynamic> json) => LinkFivePlan(
      productId: json["productId"],
      planId: json["planId"],
      rootId: json["rootId"],
      purchaseDate: DateTime.parse(json["purchaseDate"]),
      endDate: DateTime.parse(json["endDate"]),
      storeType: json["storeType"],
      customerUserId: json["customerUserId"],
      isTrial: json["isTrial"],
      familyName: json["familyName"],
      attributes: json["attributes"],
      duration: json["duration"]);

  Map<String, dynamic> get json => {
        "productId": productId,
        "planId": planId,
        "purchaseDate": purchaseDate,
        "endDate": endDate,
        "storeType": storeType,
        "customerUserId": customerUserId,
        "isTrial": isTrial,
        "familyName": familyName,
        "attributes": attributes,
        "duration": duration,
      };

  static List<LinkFivePlan> fromJsonList(Map<String, dynamic> json) =>
      (json["planList"] as List).map((e) => LinkFivePlan.fromJson(e)).toList();

  @override
  String toString() {
    return 'LinkFivePlan: $json}';
  }

  /// Period of the subscription
  Period get planDuration => Period.fromLinkFive(duration!);
}
