import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_restore_apple_item.dart';
import 'package:linkfive_purchases/models/linkfive_restore_google_item.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';

/// HTTP client to LinkFive
abstract class LinkFiveClientInterface {
  init(LinkFiveEnvironment env, LinkFiveAppDataStore appDataStore);

  /// Call to LinkFive to get the subscriptions to show
  Future<LinkFiveResponseData> fetchLinkFiveResponse();

  /// after a purchase on ios we call the purchases/apple
  /// We don't need to do this on Android
  Future<LinkFiveActiveProducts> purchaseIos(AppStoreProductDetails productDetails,
      AppStorePurchaseDetails purchaseDetails);

  /// after a purchase on Google we call the purchases/google
  /// We don't need to do this on Android
  Future<LinkFiveActiveProducts> purchaseGooglePlay(
      GooglePlayPurchaseDetails purchaseDetails, GooglePlayProductDetails productDetails);

  /// after a one time purchase purchase on Google we post the data to LinkFIve
  Future<LinkFiveActiveProducts> purchaseGooglePlayOneTimePurchase(
      GooglePlayPurchaseDetails purchaseDetails, OneTimePurchaseOfferDetailsWrapper otpDetails);

  /// Fetches the receipts for a user
  ///
  /// if no LinkFive UUID is provided, LinkFive will generate a new user ID
  ///
  Future<LinkFiveActiveProducts> fetchUserPlanListFromLinkFive();

  /// RESTORE APPLE APP STORE
  ///
  /// This will send all restored transactionIds to LinkFive
  /// We will check against apple if those transaction are valid and
  /// enable or disable a product
  Future<LinkFiveActiveProducts> restoreIos(
      List<LinkFiveRestoreAppleItem> restoreList);

  /// RESTORE GOOGLE PLAY STORE
  ///
  /// This will send all restored transactionIds to LinkFive
  /// We will check against apple if those transaction are valid and
  /// enable or disable a product
  Future<LinkFiveActiveProducts> restoreGoogle(
      List<LinkFiveRestoreGoogleItem> restoreList);

  /// Should change the USER ID.
  Future<LinkFiveActiveProducts> changeUserId(String? userId);
}
