import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:linkfive_purchases/client/linkfive_client_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';

/// HTTP TEST client
class LinkFiveClientTest extends LinkFiveClientInterface {
  /// Does Nothing
  @override
  init(LinkFiveEnvironment env, LinkFiveAppDataStore appDataStore) {}

  /// TEST MODE
  @override
  Future<LinkFiveResponseData> fetchLinkFiveResponse() async {
    return _testData;
  }

  /// TEST MODE
  @override
  Future<LinkFiveActiveProducts> purchaseIos({
    required AppStoreProductDetails? productDetails,
    required AppStorePurchaseDetails purchaseDetails,
  }) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<LinkFiveActiveProducts> purchaseGooglePlay(
      GooglePlayPurchaseDetails purchaseDetails, GooglePlayProductDetails productDetails) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<LinkFiveActiveProducts> fetchUserPlanListFromLinkFive() async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<LinkFiveActiveProducts> restoreIos(List<LinkFiveRestoreAppleItem> restoreList) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<LinkFiveActiveProducts> restoreGoogle(List<LinkFiveRestoreGoogleItem> restoreList) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<LinkFiveActiveProducts> changeUserId(String? userId) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  LinkFiveActiveProducts _parsePlanListResponse() {
    return LinkFiveActiveProducts.fromJson({
      "planList": [
        {
          "productId": "test_1",
          "planId": "linkfive-test-plan-id",
          "rootId": "linkfive-test-root-id",
          "purchaseDate": DateTime.now().toIso8601String(),
          "endDate": DateTime.now().add(const Duration(days: 90)).toIso8601String(),
          "storeType": "LINKFIVE_TEST_STORE",
          "duration": "P3M"
        }
      ],
      "oneTimePurchaseList": []
    });
  }

  /// TEST MODE
  LinkFiveResponseData get _testData {
    return LinkFiveResponseData("TEST", null, [1, 2].map((e) => LinkFiveResponseDataSubscription("test_$e")).toList(),
        [LinkFiveResponseDataOneTimePurchase("test_otp_1")]);
  }

  @override
  Future<LinkFiveActiveProducts> purchaseGooglePlayOneTimePurchase(
      GooglePlayPurchaseDetails purchaseDetails, OneTimePurchaseOfferDetailsWrapper otpDetails) async {
    return LinkFiveActiveProducts.empty();
  }
}
