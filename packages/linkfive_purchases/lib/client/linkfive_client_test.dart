import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:linkfive_purchases/client/linkfive_client_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_restore_apple_item.dart';
import 'package:linkfive_purchases/models/linkfive_restore_google_item.dart';
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
  Future<List<LinkFivePlan>> purchaseIos(
      AppStoreProductDetails productDetails, AppStorePurchaseDetails purchaseDetails) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<List<LinkFivePlan>> purchaseGooglePlay(
      GooglePlayPurchaseDetails purchaseDetails, GooglePlayProductDetails productDetails) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<List<LinkFivePlan>> fetchUserPlanListFromLinkFive() async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<List<LinkFivePlan>> restoreIos(List<LinkFiveRestoreAppleItem> restoreList) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<List<LinkFivePlan>> restoreGoogle(List<LinkFiveRestoreGoogleItem> restoreList) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  @override
  Future<List<LinkFivePlan>> changeUserId(String? userId) async {
    return _parsePlanListResponse();
  }

  /// TEST MODE
  List<LinkFivePlan> _parsePlanListResponse() {
    return LinkFivePlan.fromJsonList({
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
      ]
    });
  }

  /// TEST MODE
  LinkFiveResponseData get _testData {
    return LinkFiveResponseData(
        "TEST", null, [1, 2].map((e) => LinkFiveResponseDataSubscription("test_$e")).toList(growable: false));
  }
}
