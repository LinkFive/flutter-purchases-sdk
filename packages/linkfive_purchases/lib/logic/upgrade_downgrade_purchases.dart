import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

extension UpgradeDowngradePurchases on LinkFivePurchasesMain {
  /// Handles the Up and Downgrade of a Subscription plan
  /// [oldPurchaseDetails] given by the LinkFive Plugin
  /// [productDetails] from the purchases you want to switch to
  /// [prorationMode] default replaces immediately the subscription, and the remaining time will be prorated and credited to the user.
  ///   Check https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.ProrationMode for more information
  ///
  Future<bool> handleAndroidSwitchPlan(
      LinkFivePlan oldLinkFivePlan, LinkFiveProductDetails productDetails,
      {ProrationMode? prorationMode}) async {
    GooglePlayPurchaseDetails? _oldPurchase =
        await getAndroidPurchase(oldLinkFivePlan);

    // If null, return false
    if (_oldPurchase == null) {
      LinkFiveLogger.e("Old Purchase not found");
      return false;
    }

    // create the upgrade or downgrade Purchase param
    GooglePlayPurchaseParam googlePlayPurchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails.productDetails,
        changeSubscriptionParam: ChangeSubscriptionParam(
            oldPurchaseDetails: _oldPurchase, prorationMode: prorationMode));

    // init the purchase
    return InAppPurchase.instance
        .buyNonConsumable(purchaseParam: googlePlayPurchaseParam);
  }

  /// Search an existing Android Purchase by a given LinkFiveVerifiedReceipt
  /// Returns null if not found
  Future<GooglePlayPurchaseDetails?> getAndroidPurchase(
      LinkFivePlan linkFivePlan) async {
    // get old Purchase from past purchases
    final androidExtension = InAppPurchase.instance
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final pastPurchases =
        (await androidExtension.queryPastPurchases()).pastPurchases;

    for (int i = 0; i < pastPurchases.length; i++) {
      if (linkFivePlan.productId == pastPurchases[i].productID) {
        return pastPurchases[i];
      }
    }
    return null;
  }

  /// Handles the Up and Downgrade of a Subscription plans
  /// Apple does not need the existing plan.
  Future<bool> handleIosSwitchPlan(
      LinkFiveProductDetails productDetails) async {
    // init the purchase
    return InAppPurchase.instance.buyNonConsumable(
        purchaseParam:
            PurchaseParam(productDetails: productDetails.productDetails));
  }
}
