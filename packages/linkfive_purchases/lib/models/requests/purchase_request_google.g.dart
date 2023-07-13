// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_google.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
