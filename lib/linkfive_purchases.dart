import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:linkfive_purchases/client/linkfive_client.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client.dart';
import 'package:linkfive_purchases/logger/linkfive_logger.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_verified_receipt.dart';
import 'package:linkfive_purchases/store/link_five_store.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';

class LinkFivePurchases {
  // Singleton
  static LinkFivePurchases _instance = LinkFivePurchases._();

  LinkFivePurchases._();

  static init(
    String apiKey, {
    LinkFiveLogLevel logLevel = LinkFiveLogLevel.DEBUG,
    LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION,
  }) async {
    LinkFiveLogger.setLogLevel(logLevel);
    await _instance._initialize(apiKey, env: env);
  }

  static fetchSubscriptions() {
    _instance._fetchSubscriptions();
  }

  static restore() async {
    await InAppPurchase.instance.restorePurchases();
  }

  static purchase(ProductDetails productDetails) async {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    var showBuySuccess = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    LinkFiveLogger.d("Show Buy Intent success: $showBuySuccess");
  }

  static Stream<LinkFiveResponseData?> listenOnResponseData() => _instance.store.listenOnResponseData();

  static Stream<LinkFiveSubscriptionData?> listenOnSubscriptionData() => _instance.store.listenOnSubscriptionData();

  static Stream<LinkFiveActiveSubscriptionData?> listenOnActiveSubscriptionData() =>
      _instance.store.listenOnActiveSubscriptionData();

  static setUTMSource(String? utmSource){
    _instance.appDataStore.utmSource = utmSource;
  }
  static setEnvironment(String? environment){
    _instance.appDataStore.environment = environment;
  }
  static setUserId(String? userId){
    _instance.appDataStore.userId = userId;
  }

  // members
  LinkFiveClient client = LinkFiveClient();
  LinkFiveBillingClient billingClient = LinkFiveBillingClient();
  LinkFiveStore store = LinkFiveStore();
  LinkFiveAppDataStore appDataStore = LinkFiveAppDataStore();

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  _initialize(String apiKey,
      {LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION}) async {
    appDataStore.apiKey = apiKey;
    client.init(env, appDataStore);

    LinkFiveLogger.d("init LinkFive");

    billingClient.init(client);

    _listenPurchaseUpdates();
    _loadActiveSubs();
  }

  void _listenPurchaseUpdates() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      LinkFiveLogger.d("purchaseListener is DONE");
      _subscription?.cancel();
    }, onError: (error) {
      // handle error here.
      LinkFiveLogger.e("ERROR $error");
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    LinkFiveLogger.d("got PurchaseUpdated");
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          LinkFiveLogger.d("_showPendingUI();");
          break;
        case PurchaseStatus.error:
          LinkFiveLogger.e("_handleError(purchaseDetails.error!)");
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handlePurchasedPurchaseDetails(purchaseDetails);
          break;
        default:
          break;
      }
    });
  }

  _handlePurchasedPurchaseDetails(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.pendingCompletePurchase) {
      // always on ios. android can be done locally or on server
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    }

    if (Platform.isAndroid) {
      // await client.sendPurchaseToServer(purchaseDetails);
      await _loadActiveSubs();
    } else if (Platform.isIOS) {
      await _loadActiveSubs();
    }
  }

  _fetchSubscriptions() async {
    LinkFiveLogger.d("fetch subscriptions");
    var linkFiveResponse = await client.fetchLinkFiveResponse();
    store.onNewResponseData(linkFiveResponse);

    var platformSubscriptions = await billingClient.getPlatformSubscriptions(linkFiveResponse);
    if (platformSubscriptions != null) {
      store.onNewPlatformSubscriptions(platformSubscriptions);
    }
  }

  ///
  /// LOAD ACTIVE SUBS
  ///
  _loadActiveSubs() async {
    LinkFiveLogger.d("load active subs");
    final verifiedReceiptsList = await billingClient.verifiedReceipts;

    // update listeners
    store.onNewLinkFiveActiveSubDetails(LinkFiveActiveSubscriptionData(verifiedReceiptsList));
  }
}
