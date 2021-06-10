class LinkFiveResponseData {
  final String platform;
  final String? attributes;
  final List<LinkFiveResponseDataSubscription> subscriptionList;

  LinkFiveResponseData(this.platform, this.attributes, this.subscriptionList);

  LinkFiveResponseData.fromJson(Map<Object?, Object?> json)
      : platform = json["platform"] as String,
        attributes = json["attributes"] as String,
        subscriptionList = (json["subscriptionList"] as List).map((e) => LinkFiveResponseDataSubscription(e)).toList()
  ;
}

class LinkFiveResponseDataSubscription {
  final String sku;

  LinkFiveResponseDataSubscription(this.sku);

  LinkFiveResponseDataSubscription.fromJson(Map<Object?, Object?> json) : sku = json["sku"] as String;
}
