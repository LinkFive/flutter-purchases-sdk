import 'package:in_app_purchase/in_app_purchase.dart';

class LinkFiveVerifiedReceipt {
  LinkFiveVerifiedReceipt({
    required this.sku,
    this.purchaseId,
    required this.transactionDate,
    this.validUntilDate,
    required this.status,
    this.isTrial,
    required this.isExpired,
  });

  String sku;
  String? purchaseId;
  DateTime transactionDate;
  DateTime? validUntilDate;
  int status;
  bool? isTrial;
  bool isExpired;

  /// Makes a [LinkFiveVerifiedReceipt] from [PurchaseDetails].
  factory LinkFiveVerifiedReceipt.fromPurchaseDetails(
          PurchaseDetails details) =>
      LinkFiveVerifiedReceipt(
          isExpired: false,
          sku: details.productID,
          purchaseId: details.purchaseID,
          transactionDate: DateTime.parse(details.transactionDate!),
          status: details.status.index);

  factory LinkFiveVerifiedReceipt.fromJson(Map<String, dynamic> json) =>
      LinkFiveVerifiedReceipt(
        sku: json["sku"],
        purchaseId: json["purchaseId"],
        transactionDate: DateTime.parse(json["transactionDate"]),
        validUntilDate: DateTime.parse(json["validUntilDate"]),
        status: json["status"],
        isTrial: json["isTrial"],
        isExpired: json["isExpired"],
      );

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "purchaseId": purchaseId,
        "transactionDate": transactionDate,
        "validUntilDate": validUntilDate,
        "status": status,
        "isTrial": isTrial,
        "isExpired": isExpired,
      };
}
