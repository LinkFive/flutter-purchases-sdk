import 'package:linkfive_purchases/models/linkfive_one_time_purchase.dart';
import 'package:linkfive_purchases/models/linkfive_plan.dart';

/// All active and valid LinkFive plans & Products
class LinkFiveActiveProducts {
  /// All active plans
  final List<LinkFivePlan> planList;
  final List<LinkFiveOneTimePurchase> oneTimePurchaseList;

  LinkFiveActiveProducts._({required this.oneTimePurchaseList, required this.planList});

  LinkFiveActiveProducts.fromJson(Map<String, dynamic> json)
      : this._(
          oneTimePurchaseList: LinkFiveOneTimePurchase.fromJsonList(json),
          planList: LinkFivePlan.fromJsonList(json),
        );

  LinkFiveActiveProducts.empty()
      : planList = [],
        oneTimePurchaseList = [];

  bool get isNotEmpty => oneTimePurchaseList.isNotEmpty || planList.isNotEmpty;

  @override
  String toString() {
    return "OTP: $oneTimePurchaseList, Subs: $planList";
  }
}

extension LinkFiveActiveProductsExtension on LinkFiveActiveProducts? {
  /// Simple & handy copy with method
  LinkFiveActiveProducts copyWith({
    List<LinkFivePlan>? planList,
    List<LinkFiveOneTimePurchase>? oneTimePurchaseList,
  }) {
    return LinkFiveActiveProducts._(
        planList: switch (planList) { null => this?.planList ?? [], _ => planList },
        oneTimePurchaseList: switch (oneTimePurchaseList) {
          null => this?.oneTimePurchaseList ?? [],
          _ => oneTimePurchaseList
        });
  }
}
