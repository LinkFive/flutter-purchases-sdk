import 'package:linkfive_purchases/models/linkfive_plan.dart';

/// A single restored Google Transaction
class LinkFiveRestoreGoogleItem {
  /// SKU item, for example: yearly_pro_2022
  final String sku;

  /// the id of the purchase
  final String purchaseId;

  /// Purchase token we can use to communicate with Google
  final String purchaseToken;

  LinkFiveRestoreGoogleItem(
      {required this.sku,
      required this.purchaseId,
      required this.purchaseToken});

  Map<String,dynamic> get toMap {
    return {
      "sku": this.sku,
      "purchaseId": this.purchaseId,
      "purchaseToken": this.purchaseToken
    };
  }

  @override
  String toString() {
    return "{"
        "\"sku\": \"$sku\","
        "\"purchaseId\": \"$purchaseId\","
        "\"purchaseToken\": \"$purchaseToken\""
        "}";
  }
}
