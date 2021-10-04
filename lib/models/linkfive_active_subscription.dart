import 'package:linkfive_purchases/models/linkfive_verified_receipt.dart';

/// Model for subscriptions to offer to the user
class LinkFiveActiveSubscriptionData {
  /// these subscriptions are available for purchase
  final List<LinkFiveVerifiedReceipt> subscriptionList;

  LinkFiveActiveSubscriptionData(this.subscriptionList);
}
