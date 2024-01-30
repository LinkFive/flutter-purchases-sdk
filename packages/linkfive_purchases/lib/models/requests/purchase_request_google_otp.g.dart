// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_google_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseRequestOneTimePurchaseGoogle
    _$PurchaseRequestOneTimePurchaseGoogleFromJson(Map<String, dynamic> json) =>
        PurchaseRequestOneTimePurchaseGoogle(
          productId: json['productId'] as String,
          purchaseToken: json['purchaseToken'] as String,
          orderId: json['orderId'] as String,
          priceAmountMicros: json['priceAmountMicros'] as int,
          priceCurrencyCode: json['priceCurrencyCode'] as String,
        );

Map<String, dynamic> _$PurchaseRequestOneTimePurchaseGoogleToJson(
        PurchaseRequestOneTimePurchaseGoogle instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'purchaseToken': instance.purchaseToken,
      'orderId': instance.orderId,
      'priceAmountMicros': instance.priceAmountMicros,
      'priceCurrencyCode': instance.priceCurrencyCode,
    };
