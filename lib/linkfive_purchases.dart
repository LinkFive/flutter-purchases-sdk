import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:linkfive_purchases/client/linkfive_client.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client.dart';
import 'package:linkfive_purchases/logger/linkfive_logger.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases/store/link_five_store.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';

class LinkFivePurchases {
  // Singleton
  static LinkFivePurchases _instance = LinkFivePurchases._();

  LinkFivePurchases._();

  static init(
    String apiKey, {
    bool acknowledgeLocally = false,
    LinkFiveLogLevel logLevel = LinkFiveLogLevel.DEBUG,
    LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION,
  }) async {
    LinkFiveLogger.setLogLevel(logLevel);
    await _instance._initialize(apiKey, acknowledgeLocally: acknowledgeLocally, env: env);
  }

  static fetchSubscriptions() {
    _instance._fetchSubscriptions();
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
      {bool acknowledgeLocally = false, LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION}) async {
    appDataStore.apiKey = apiKey;
    appDataStore.acknowledgeLocally = acknowledgeLocally;
    client.init(env);

    LinkFiveLogger.d("init LinkFive");
    billingClient.init();

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
      if (purchaseDetails.status == PurchaseStatus.pending) {
        LinkFiveLogger.d("_showPendingUI();");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          LinkFiveLogger.e("_handleError(purchaseDetails.error!)");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // send to server
          client.sendPurchaseToServer(appDataStore.apiKey, purchaseDetails);

          // todo validate
          bool valid = true; // await _verifyPurchase(purchaseDetails);
          if (valid) {
            _onNewPurchaseFromListener(purchaseDetails);
          } else {
            print("_handleInvalidPurchase(purchaseDetails);");
          }
        }
        if (appDataStore.acknowledgeLocally) {
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      }
    });
  }

  _fetchSubscriptions() async {
    LinkFiveLogger.d("fetch subscriptions");
    var linkFiveResponse = await client.fetchLinkFiveResponse(appDataStore);
    store.onNewResponseData(linkFiveResponse);

    var platformSubscriptions = await billingClient.getPlatformSubscriptions(linkFiveResponse);
    if (platformSubscriptions != null) {
      store.onNewPlatformSubscriptions(platformSubscriptions);
    }
    // SKReceiptManager.retrieveReceiptData();
  }

  _loadActiveSubs() async {
    LinkFiveLogger.d("load active subs");
    var purchasedProducts = await billingClient.loadPurchasedProducts();
    store.onNewPurchasedProducts(purchasedProducts);
    if (purchasedProducts == null || purchasedProducts.isEmpty) {
      LinkFiveLogger.d("no purchases found");
      return;
    }
    LinkFiveLogger.d("purchased: $purchasedProducts");
    var linkFiveActiveSubscriptionData = await client.fetchSubscriptionDetails(appDataStore.apiKey, purchasedProducts);
    store.onNewLinkFiveActiveSubDetails(linkFiveActiveSubscriptionData);
  }

  _onNewPurchaseFromListener(PurchaseDetails purchaseDetails) async {
    store.onNewPurchasedProducts([purchaseDetails], reset: false);

    var linkFiveActiveSubscriptionData = await client.fetchSubscriptionDetails(appDataStore.apiKey, [purchaseDetails]);
    store.onNewLinkFiveActiveSubDetails(linkFiveActiveSubscriptionData, reset: false);
  }
}
