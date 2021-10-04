/// Verified Receipt from LinkFive including all data
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
}
