import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:linkfive_purchases/client/linkfive_client.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases/store/link_five_store.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:in_app_purchase_ios/src/store_kit_wrappers/sk_receipt_manager.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

class LinkFivePurchases {
  // Singleton
  static LinkFivePurchases _instance = LinkFivePurchases._();

  LinkFivePurchases._();

  static init(String apiKey, {acknowledgeLocally = false}) async {
    await _instance._initialize(apiKey, acknowledgeLocally: acknowledgeLocally);
  }

  static fetchSubscriptions() {
    _instance._fetchSubscriptions();
  }

  static purchase(ProductDetails productDetails) async {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    var showBuySuccess = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    print("Show Buy Intent success: $showBuySuccess");

  }

  static Stream<LinkFiveResponseData?> listenOnResponseData() => _instance.store.listenOnResponseData();
  static Stream<LinkFiveSubscriptionData?> listenOnSubscriptionData() => _instance.store.listenOnSubscriptionData();
  static Stream<LinkFiveActiveSubscriptionData?> listenOnActiveSubscriptionData() => _instance.store.listenOnActiveSubscriptionData();

  // members
  LinkFiveClient client = LinkFiveClient();
  LinkFiveBillingClient billingClient = LinkFiveBillingClient();
  LinkFiveStore store = LinkFiveStore();

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  String apiKey = "";
  bool acknowledgeLocally = false;

  _initialize(String apiKey, {acknowledgeLocally = false}) async {
    print("init LinkFive");
    this.apiKey = apiKey;
    this.acknowledgeLocally = acknowledgeLocally;
    billingClient.init();

    _listenPurchaseUpdates();
    _loadActiveSubs();
  }

  void _listenPurchaseUpdates() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print("purchaseListener is DONE");
      _subscription?.cancel();
    }, onError: (error) {
      // handle error here.
      print("ERROR $error");
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print("got PurchaseUpdated");
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("_showPendingUI();");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("_handleError(purchaseDetails.error!)");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {

          // send to server
          client.sendPurchaseToServer(apiKey, purchaseDetails);

          // todo validate
          bool valid = true; // await _verifyPurchase(purchaseDetails);
          if (valid) {
            _onNewPurchaseFromListener(purchaseDetails);
          } else {
            print("_handleInvalidPurchase(purchaseDetails);");
          }
        }
        if(acknowledgeLocally) {
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      }
    });
  }

  _fetchSubscriptions() async {
    print("fetch subscriptions");
    var linkFiveResponse = await client.fetchLinkFiveResponse(apiKey);
    store.onNewResponseData(linkFiveResponse);

    var platformSubscriptions = await billingClient.getPlatformSubscriptions(linkFiveResponse);
    if(platformSubscriptions != null) {
      store.onNewPlatformSubscriptions(platformSubscriptions);
    }
    // var test = await SKReceiptManager.retrieveReceiptData();

    // InAppPurchase.instance.restorePurchases();
    // var ios = InAppPurchase.instance.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
    
    // var qwe = await ios.refreshPurchaseVerificationData();
    //var asdljasldj = InAppPurchasePlatform.instance as InAppPurchaseAndroidPlatform;
    //var qwe = InAppPurchasePlatform.instance as InAppPurchaseIosPlatform;
    // qwe.observer
    // SKReceiptManager.retrieveReceiptData();
    //var android = InAppPurchase.instance.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    //var pastPurchases = await android.queryPastPurchases();
    /*pastPurchases.pastPurchases.forEach((element) {
      print("past: ${element.productID}");
    });*/

  }

  _loadActiveSubs() async {
    print("load active subs");
    var purchasedProducts = await billingClient.loadPurchasedProducts();
    store.onNewPurchasedProducts(purchasedProducts);
    if(purchasedProducts == null || purchasedProducts.isEmpty){
      print("no purchases found");
      return;
    }
    print("purchased: $purchasedProducts");
    var linkFiveActiveSubscriptionData = await client.fetchSubscriptionDetails(this.apiKey, purchasedProducts);
    store.onNewLinkFiveActiveSubDetails(linkFiveActiveSubscriptionData);
  }

  _onNewPurchaseFromListener(PurchaseDetails purchaseDetails) async {
    store.onNewPurchasedProducts([purchaseDetails], reset: false);

    var linkFiveActiveSubscriptionData = await client.fetchSubscriptionDetails(this.apiKey, [purchaseDetails]);
    store.onNewLinkFiveActiveSubDetails(linkFiveActiveSubscriptionData, reset: false);
  }

}
