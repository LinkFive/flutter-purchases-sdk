/// A single restored Apple TransactionId
class LinkFiveRestoreAppleItem {
  /// a non null transactionId
  final String transactionId;
  final String? originalTransactionId;

  LinkFiveRestoreAppleItem(
      {required this.transactionId, this.originalTransactionId});

  Map<String, dynamic> get toMap {
    return {
      "transactionId": transactionId,
      "originalTransactionId": originalTransactionId ?? transactionId
    };
  }

  @override
  String toString() {
    return "{"
        "\"transactionId\": \"$transactionId\","
        "\"originalTransactionId\": \"$originalTransactionId\""
        "}";
  }
}
