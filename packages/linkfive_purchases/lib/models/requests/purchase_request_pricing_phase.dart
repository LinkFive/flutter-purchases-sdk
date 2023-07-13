import 'package:json_annotation/json_annotation.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

part 'purchase_request_pricing_phase.g.dart';

@JsonSerializable()
class PurchaseRequestPricingPhase {
  final int billingCycleCount;
  final String billingPeriod;
  final String recurrence;

  const PurchaseRequestPricingPhase(this.billingCycleCount, this.billingPeriod, this.recurrence);

  factory PurchaseRequestPricingPhase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestPricingPhaseFromJson(json);

  static PurchaseRequestPricingPhase fromPricingPhase(PricingPhase pricingPhase) {
    return PurchaseRequestPricingPhase(
        pricingPhase.billingCycleCount, pricingPhase.billingPeriod.jsonValue, pricingPhase.recurrence.jsonValue);
  }

  Map<String, dynamic> toJson() => _$PurchaseRequestPricingPhaseToJson(this);
}

class PurchaseRequestPricingPhaseListConverter
    implements JsonConverter<List<PurchaseRequestPricingPhase>, List<Map<String, dynamic>>> {
  const PurchaseRequestPricingPhaseListConverter();

  @override
  List<PurchaseRequestPricingPhase> fromJson(List<Map<String, dynamic>> json) =>
      [for (final phase in json) PurchaseRequestPricingPhase.fromJson(phase)];

  @override
  List<Map<String, dynamic>> toJson(List<PurchaseRequestPricingPhase> object) {
    return [for (final phase in object) phase.toJson()];
  }
}
