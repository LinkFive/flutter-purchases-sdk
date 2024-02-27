import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';

/// Internal Billing Client. It holds the connection to the native billing sdk
abstract class LinkFiveBillingClientInterface {
  /// load the products from the native billing sdk
  Future<List<ProductDetails>?> getPlatformProducts(
      LinkFiveResponseData linkFiveResponse);
}
