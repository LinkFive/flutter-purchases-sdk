// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_pricing_phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseRequestPricingPhase _$PurchaseRequestPricingPhaseFromJson(
        Map<String, dynamic> json) =>
    PurchaseRequestPricingPhase(
      json['billingCycleCount'] as int,
      json['billingPeriod'] as String,
      json['recurrence'] as String,
    );

Map<String, dynamic> _$PurchaseRequestPricingPhaseToJson(
        PurchaseRequestPricingPhase instance) =>
    <String, dynamic>{
      'billingCycleCount': instance.billingCycleCount,
      'billingPeriod': instance.billingPeriod,
      'recurrence': instance.recurrence,
    };
