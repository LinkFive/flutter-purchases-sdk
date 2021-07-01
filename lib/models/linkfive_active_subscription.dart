import 'package:in_app_purchase/in_app_purchase.dart';

class LinkFiveActiveSubscriptionData {
  final List<LinkFivePurchaseData> subscriptionList;

  LinkFiveActiveSubscriptionData(this.subscriptionList);

  LinkFiveActiveSubscriptionData.fromJson(Map<Object?, Object?> json)
      : subscriptionList = (json["subscriptionList"] as List).map((e) => LinkFivePurchaseData.fromJson(e)).toList()
  ;
}

class LinkFivePurchaseData {
  final String? sku;
  final String? familyName;
  final String? attributes;
  PurchaseDetails? purchaseDetails = null;

  LinkFivePurchaseData(this.sku, this.familyName, this.attributes);

  LinkFivePurchaseData.fromJson(Map<Object?, Object?> json)
      : sku = json["sku"] as String?,
        familyName = json["familyName"] as String?,
        attributes = json["attributes"] as String?;

}

