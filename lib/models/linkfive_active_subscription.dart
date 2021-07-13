import 'package:linkfive_purchases/models/linkfive_verified_receipt.dart';

class LinkFiveActiveSubscriptionData {
  final List<LinkFivePurchaseData> subscriptionList;

  LinkFiveActiveSubscriptionData(this.subscriptionList);

  LinkFiveActiveSubscriptionData.fromJson(Map<Object?, Object?> json)
      : subscriptionList = (json["subscriptionList"] as List)
            .map((e) => LinkFivePurchaseData.fromJson(e))
            .toList();
}

class LinkFivePurchaseData {
  final String? sku;
  final String? familyName;
  final String? attributes;
  LinkFiveVerifiedReceipt? verifiedReceipt;

  LinkFivePurchaseData(this.sku, this.familyName, this.attributes);

  LinkFivePurchaseData.fromJson(Map<Object?, Object?> json)
      : sku = json["sku"] as String?,
        familyName = json["familyName"] as String?,
        attributes = json["attributes"] as String?;
}
