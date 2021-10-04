import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/client/linkfive_client.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client.dart';
import 'package:linkfive_purchases/default/default_purchase_handler.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';
import 'package:linkfive_purchases/purchases.dart';
import 'package:linkfive_purchases/store/link_five_store.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';

class LinkFivePurchasesMain extends DefaultPurchaseHandler
    implements CallbackInterface {
  //#region Singleton
  LinkFivePurchasesMain._();

  static LinkFivePurchasesMain _instance = LinkFivePurchasesMain._();

  factory LinkFivePurchasesMain() => _instance;

  //#endregion Singleton

  //#region Members
  /// Cache of AppStoreProductDetail
  AppStoreProductDetails? _productDetailsToPurchase;

  /// LinkFive HTTP Client
  LinkFiveClient client = LinkFiveClient();

  /// Billing Client to Store
  LinkFiveBillingClient billingClient = LinkFiveBillingClient();

  /// Internal Store for data
  LinkFiveStore store = LinkFiveStore();

  /// Settings data Store
  LinkFiveAppDataStore appDataStore = LinkFiveAppDataStore();

  StreamSubscription<List<PurchaseDetails>>? _purchaseStream;

  /// Response Data as Stream
  Stream<LinkFiveResponseData?> listenOnResponseData() =>
      store.listenOnResponseData();

  /// Subscription Data as Stream
  Stream<LinkFiveSubscriptionData?> listenOnSubscriptionData() =>
      store.listenOnSubscriptionData();

  /// Active Subscription as Stream
  Stream<LinkFiveActiveSubscriptionData?> listenOnActiveSubscriptionData() =>
      store.listenOnActiveSubscriptionData();

  //#endregion Members

  /// Initialize the LinkFive client
  Future<void> init(String apiKey,
      {LinkFiveLogLevel logLevel = LinkFiveLogLevel.DEBUG,
      LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION}) async {
    LinkFiveLogger.setLogLevel(logLevel);
    appDataStore.apiKey = apiKey;
    client.init(env, appDataStore);

    LinkFiveLogger.d("init LinkFive");

    billingClient.init(client);

    _listenPurchaseUpdates();
    _loadActiveSubs();
  }

  /// Fetches the subscriptions from LinkFive and retreives the IAP from the platform
  fetchSubscriptions() async {
    LinkFiveLogger.d("fetch subscriptions");
    var linkFiveResponse = await client.fetchLinkFiveResponse();
    store.onNewResponseData(linkFiveResponse);

    var platformSubscriptions =
        await billingClient.getPlatformSubscriptions(linkFiveResponse);
    if (platformSubscriptions != null) {
      store.onNewPlatformSubscriptions(platformSubscriptions);
    }
  }

  /// Make a purchase
  ///
  /// If you want to know if the purchase is pending, listen to [listenOnPendingPurchase]
  /// @returns true if UI is shown, false otherwise
  Future<bool> purchase(dynamic productDetails) async {
    ProductDetails? _productDetails;
    if (productDetails is ProductDetails) {
      _productDetails = productDetails;
    }
    if (productDetails is SubscriptionData) {
      if (productDetails.productDetails != null &&
          productDetails.productDetails is ProductDetails) {
        _productDetails = productDetails.productDetails;
      }
    }
    if (_productDetails == null) {
      LinkFiveLogger.d("No ProductDetails to purchase found");
      return false;
    }

    final purchaseParam = PurchaseParam(productDetails: _productDetails);
    var showBuySuccess = false;

    // For LinkFive Analytics purposes
    if (Platform.isIOS == true) {
      LinkFiveLogger.d("Save product details because of ios");
      _productDetailsToPurchase = _productDetails as AppStoreProductDetails;
    }

    try {
      // try to buy it
      LinkFiveLogger.d("try to purchase item 1/2");
      showBuySuccess = await InAppPurchase.instance
          .buyNonConsumable(purchaseParam: purchaseParam);
    } on PlatformException catch (e) {
      LinkFiveLogger.e(e);
      if (Platform.isIOS) {
        /// Exception could be:
        /// Unhandled Exception: PlatformException(storekit_duplicate_product_object, There is a pending transaction for the same product identifier. Please either wait for it to be finished or finish it manually using `completePurchase` to avoid edge cases., {applicationUsername: null, requestData: null, quantity: 1, productIdentifier: quarterly_pro_2020_4, simulatesAskToBuyInSandbox: false}, null)

        // https://github.com/flutter/flutter/issues/60763#issuecomment-769051089
        // try to clear the transactions
        LinkFiveLogger.d("Finish previous transactions");
        var transactions = await SKPaymentQueueWrapper().transactions();
        transactions.forEach((skPaymentTransactionWrapper) async {
          await SKPaymentQueueWrapper()
              .finishTransaction(skPaymentTransactionWrapper);
        });

        // try to restore
        await restore();

        LinkFiveLogger.d("try to purchase item 2/2");
        // try buy again
        showBuySuccess = await InAppPurchase.instance
            .buyNonConsumable(purchaseParam: purchaseParam);
      }
    }

    LinkFiveLogger.d("Show Buy Intent success: $showBuySuccess");
    // set Pending Purchase. this will notify all listeners
    if (showBuySuccess) {
      super.isPendingPurchase = true;
    }
    return showBuySuccess;
  }

  /// Restore
  /// Restore a Purchase
  Future<bool> restore() async {
    super.isPendingPurchase = true;
    await InAppPurchase.instance.restorePurchases();
    return false;
  }

  setUTMSource(String? utmSource) {
    appDataStore.utmSource = utmSource;
  }

  setEnvironment(String? environment) {
    appDataStore.environment = environment;
  }

  setUserId(String? userId) {
    appDataStore.userId = userId;
  }

  //#region private methods

  /// LOAD ACTIVE SUBS
  _loadActiveSubs() async {
    LinkFiveLogger.d("load active subs");
    final verifiedReceiptsList = await billingClient.verifiedReceipts;

    // update listeners
    store.onNewLinkFiveActiveSubDetails(
        LinkFiveActiveSubscriptionData(verifiedReceiptsList));
    if (verifiedReceiptsList.length > 0) {
      super.purchaseState = PurchaseState.PURCHASED;
    } else {
      super.purchaseState = PurchaseState.NOT_PURCHASED;
    }
  }

  /// connects to the internal IAP library
  void _listenPurchaseUpdates() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _purchaseStream = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      LinkFiveLogger.d("purchaseListener is DONE");
      _purchaseStream?.cancel();
    }, onError: (error) {
      // handle error here.
      LinkFiveLogger.e("ERROR $error");
    });
  }

  /// Internal IAP library purchase update method
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isEmpty) {
      super.isPendingPurchase = false;
    }
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          LinkFiveLogger.d("_showPendingUI();");
          super.isPendingPurchase = true;
          break;
        case PurchaseStatus.error:
          LinkFiveLogger.e("_handleError(purchaseDetails.error!)");
          super.isPendingPurchase = false;
          break;
        case PurchaseStatus.purchased:
          if (Platform.isIOS && _productDetailsToPurchase != null) {
            final appstorePurchaseDetails =
                purchaseDetails as AppStorePurchaseDetails;
            await client.purchaseIos(
                _productDetailsToPurchase!, appstorePurchaseDetails);
            _productDetailsToPurchase = null;
          }
          await _handlePurchasedPurchaseDetails(purchaseDetails);
          super.isPendingPurchase = false;
          break;
        // if restored. this will be triggered many many times.
        // maybe we need to handle it differently since we do a request for each transaction
        case PurchaseStatus.restored:
          await _handlePurchasedPurchaseDetails(purchaseDetails);
          super.isPendingPurchase = false;
          break;
        default:
          super.isPendingPurchase = false;
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        // always on ios. android can be done locally or on server
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    });
  }

  /// Platform specific handling of loading active subs
  _handlePurchasedPurchaseDetails(PurchaseDetails purchaseDetails) async {
    if (Platform.isAndroid) {
      await _loadActiveSubs();
    } else if (Platform.isIOS) {
      await _loadActiveSubs();
    }
  }
//#endregion private methods
}
