class LinkFiveActiveSubscriptionData {
  final List<LinkFivePurchaseData> linkFivePurchaseData;

  LinkFiveActiveSubscriptionData(this.linkFivePurchaseData);

  LinkFiveActiveSubscriptionData.fromJson(Map<Object?, Object?> json)
      : linkFivePurchaseData = (json["linkFivePurchaseData"] as List).map((e) => LinkFivePurchaseData.fromJson(e)).toList()
  ;
}

class LinkFivePurchaseData {
  final String? familyName;
  final String? attributes;
  final Purchase purchase;

  LinkFivePurchaseData(this.familyName, this.attributes, this.purchase);

  LinkFivePurchaseData.fromJson(Map<Object?, Object?> json)
      : familyName = json["familyName"] as String?,
        attributes = json["attributes"] as String?,
        purchase = Purchase.fromJson(json["purchase"] as Map<Object?, Object?>);
}

class Purchase {
  final List<String> skus;
  final String orderId;
  final bool isAcknowledged;
  final int purchaseTime;
  final String purchaseToken;
  final String packageName;
  final bool isAutoRenewing;
  final int purchaseState;
  final String signature;
  final int quantity;


  Purchase(this.skus, this.orderId, this.isAcknowledged, this.purchaseTime, this.purchaseToken, this.packageName,
      this.isAutoRenewing, this.purchaseState, this.signature, this.quantity);

  Purchase.fromJson(Map<Object?, Object?> json)
      : skus = (json["skus"]! as List<Object?>).map((e) => e as String).toList(),
        orderId = json["orderId"]! as String,
        isAcknowledged = json["isAcknowledged"]! as bool,
        purchaseTime = json["purchaseTime"] as int,
        purchaseToken = json["purchaseToken"] as String,
        packageName = json["packageName"]! as String,
        isAutoRenewing = json["isAutoRenewing"]! as bool,
        purchaseState = json["purchaseState"]! as int,
        signature = json["signature"]! as String,
        quantity = json["quantity"]! as int;
}
