import 'dart:convert';

class LinkFiveSubscriptionData {
  final List<LinkFiveSkuData> linkFiveSkuData;
  final String? attributes;
  final String? error;

  LinkFiveSubscriptionData(this.linkFiveSkuData, this.attributes, this.error);

  LinkFiveSubscriptionData.fromJson(Map<Object?, Object?> json)
      : linkFiveSkuData = (json["linkFiveSkuData"] as List).map((e) =>
      LinkFiveSkuData.fromJson(e)).toList(),
        attributes = json["attributes"] as String?,
        error = json["error"] as String?;
}

class LinkFiveSkuData {
  final SkuDetails skuDetails;

  LinkFiveSkuData(this.skuDetails);

  LinkFiveSkuData.fromJson(Map<Object?, Object?> json) :
        skuDetails = SkuDetails.fromJson(json["skuDetails"] as Map<Object?, Object?>);
}

class SkuDetails {
  final String sku;
  final String subscriptionPeriod;
  final String price;
  final String? introductoryPrice;
  final String? introductoryPricePeriod;
  final String title;
  final String description;
  final String freeTrialPeriod;
  final String type;

  SkuDetails(this.sku, this.subscriptionPeriod, this.price,
      this.introductoryPrice, this.introductoryPricePeriod, this.title,
      this.description, this.freeTrialPeriod, this.type);

  SkuDetails.fromJson(Map<Object?, Object?> json)
      : sku = json["sku"]! as String,
        subscriptionPeriod = json["subscriptionPeriod"]! as String,
        price = json["price"]! as String,
        introductoryPrice = json["introductoryPrice"] as String?,
        introductoryPricePeriod = json["introductoryPricePeriod"] as String?,
        title = json["title"]! as String,
        description = json["description"]! as String,
        freeTrialPeriod = json["freeTrialPeriod"]! as String,
        type = json["type"]! as String;

}