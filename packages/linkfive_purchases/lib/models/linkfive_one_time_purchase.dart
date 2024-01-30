/// Verified Purchase
class LinkFiveOneTimePurchase {
  LinkFiveOneTimePurchase({
    required this.productId,
    required this.orderId,
    required this.purchaseDate,
    required this.storeType,
    this.customerUserId,
    this.attributes,
  });

  /// Also called productID
  String productId;

  /// Also called orderId
  String orderId;
  DateTime purchaseDate;
  String storeType;
  String? customerUserId;
  String? attributes;

  factory LinkFiveOneTimePurchase.fromJson(Map<String, dynamic> json) => LinkFiveOneTimePurchase(
        productId: json["productId"],
        orderId: json["orderId"],
        purchaseDate: DateTime.parse(json["purchaseDate"]),
        storeType: json["storeType"],
        customerUserId: json["customerUserId"],
        attributes: json["attributes"],
      );

  Map<String, dynamic> get json => {
        "productId": productId,
        "orderId": orderId,
        "purchaseDate": purchaseDate,
        "storeType": storeType,
        "customerUserId": customerUserId,
        "attributes": attributes,
      };

  static List<LinkFiveOneTimePurchase> fromJsonList(Map<String, dynamic> json) =>
      (json["oneTimePurchaseList"] as List).map((e) => LinkFiveOneTimePurchase.fromJson(e)).toList();

  @override
  String toString() {
    return 'LinkFiveOneTimePurchase: $json}';
  }
}
