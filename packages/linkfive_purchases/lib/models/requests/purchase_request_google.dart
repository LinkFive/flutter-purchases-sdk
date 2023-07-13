import 'package:json_annotation/json_annotation.dart';
import 'package:linkfive_purchases/models/requests/purchase_request_pricing_phase.dart';

part 'purchase_request_google.g.dart';

@JsonSerializable()
class PurchaseRequestGoogle {
  final String sku;
  final String purchaseId;
  final String purchaseToken;
  final String? basePlanId;
  @PurchaseRequestPricingPhaseListConverter()
  final List<PurchaseRequestPricingPhase> purchaseRequestPricingPhaseList;

  const PurchaseRequestGoogle(
      {required this.sku,
      required this.purchaseId,
      required this.purchaseToken,
      this.basePlanId,
      required this.purchaseRequestPricingPhaseList});

  Map<String, dynamic> toJson() => _$PurchaseRequestGoogleToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
