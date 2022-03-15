import 'package:linkfive_purchases/models/linkfive_plan.dart';

/// A single restored Apple TransactionId
class LinkFiveRestoreAppleItem {
  /// a non null transactionId
  final String transactionId;
  final String? originalTransactionId;

  LinkFiveRestoreAppleItem(
      {required this.transactionId, this.originalTransactionId});

  @override
  String toString() {
    return "{"
        "\"transactionId\": \"$transactionId\","
        "\"originalTransactionId\": \"$originalTransactionId\""
        "}";
  }
}
