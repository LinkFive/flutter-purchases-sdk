import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:linkfive_purchases/models/subscription_period.dart';

class LinkFiveSubscriptionData {
  final List<LinkFiveProductDetails> linkFiveSkuData;
  final String? attributes;
  final String? error;

  LinkFiveSubscriptionData(this.linkFiveSkuData, this.attributes, this.error);
}

class LinkFiveProductDetails {
  final ProductDetails productDetails;

  LinkFiveProductDetails(this.productDetails);

  SubscriptionPeriod? getSubscriptionPeriod() {
    if (productDetails is GooglePlayProductDetails) {
      GooglePlayProductDetails googleDetails =
          productDetails as GooglePlayProductDetails;
      return SubscriptionPeriodUtil.fromGoogle(
          googleDetails.skuDetails.subscriptionPeriod);
    }
    if (productDetails is AppStoreProductDetails) {
      AppStoreProductDetails iosDetails =
          productDetails as AppStoreProductDetails;
      return SubscriptionPeriodUtil.fromAppStore(
          iosDetails.skProduct.subscriptionPeriod);
    }
    return null;
  }
}
