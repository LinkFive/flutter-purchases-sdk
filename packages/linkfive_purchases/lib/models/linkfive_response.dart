/// Response Data from LinkFive
class LinkFiveResponseData {
  final String platform;
  final String? attributes;
  final List<LinkFiveResponseDataSubscription> subscriptionList;
  final List<LinkFiveResponseDataOneTimePurchase> oneTimePurchaseList;

  LinkFiveResponseData(this.platform, this.attributes, this.subscriptionList, this.oneTimePurchaseList);

  LinkFiveResponseData.fromJson(Map<Object?, Object?> json)
      : platform = json["platform"] as String,
        attributes = json["attributes"] as String?,
        subscriptionList =
            (json["subscriptionList"] as List).map((e) => LinkFiveResponseDataSubscription.fromJson(e)).toList(),
        oneTimePurchaseList = (json["oneTimePurchaseList"] as List?)
                ?.map((e) => LinkFiveResponseDataOneTimePurchase.fromJson(e))
                .toList() ??
            [];
}

class LinkFiveResponseDataSubscription {
  final String sku;

  LinkFiveResponseDataSubscription(this.sku);

  LinkFiveResponseDataSubscription.fromJson(Map<Object?, Object?> json) : sku = json["sku"] as String;
}

class LinkFiveResponseDataOneTimePurchase {
  final String productId;

  LinkFiveResponseDataOneTimePurchase(this.productId);

  LinkFiveResponseDataOneTimePurchase.fromJson(Map<Object?, Object?> json) : productId = json["productId"] as String;
}
