
import 'package:in_app_purchase/in_app_purchase.dart';

class LinkFiveSubscriptionData {
  final List<LinkFiveProductDetails> linkFiveSkuData;
  final String? attributes;
  final String? error;

  LinkFiveSubscriptionData(this.linkFiveSkuData, this.attributes, this.error);

}

class LinkFiveProductDetails {
  final ProductDetails productDetails;

  LinkFiveProductDetails(this.productDetails);

}

