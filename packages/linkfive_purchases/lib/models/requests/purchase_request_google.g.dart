// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_google.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseRequestGoogle _$PurchaseRequestGoogleFromJson(
        Map<String, dynamic> json) =>
    PurchaseRequestGoogle(
      sku: json['sku'] as String,
      purchaseId: json['purchaseId'] as String,
      purchaseToken: json['purchaseToken'] as String,
      basePlanId: json['basePlanId'] as String?,
      purchaseRequestPricingPhaseList:
          const PurchaseRequestPricingPhaseListConverter()
              .fromJson(json['purchaseRequestPricingPhaseList'] as List<Map<String, dynamic>>),
    );

Map<String, dynamic> _$PurchaseRequestGoogleToJson(
        PurchaseRequestGoogle instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'purchaseId': instance.purchaseId,
      'purchaseToken': instance.purchaseToken,
      'basePlanId': instance.basePlanId,
      'purchaseRequestPricingPhaseList':
          const PurchaseRequestPricingPhaseListConverter()
              .toJson(instance.purchaseRequestPricingPhaseList),
    };
