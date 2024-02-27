import 'package:json_annotation/json_annotation.dart';

part 'purchase_request_google_otp.g.dart';

@JsonSerializable()
class PurchaseRequestOneTimePurchaseGoogle {
  final String productId;
  final String purchaseToken;
  final String orderId;
  final int priceAmountMicros;
  final String priceCurrencyCode;

  const PurchaseRequestOneTimePurchaseGoogle({
    required this.productId,
    required this.purchaseToken,
    required this.orderId,
    required this.priceAmountMicros,
    required this.priceCurrencyCode,
  });

  Map<String, dynamic> toJson() => _$PurchaseRequestOneTimePurchaseGoogleToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
