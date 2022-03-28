import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/client/linkfive_client.dart';
import 'package:linkfive_purchases/logic/linkfive_user_management.dart';
import 'package:linkfive_purchases/logic/upgrade_downgrade_purchases.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client.dart';
import 'package:linkfive_purchases/default/default_purchase_handler.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/models/linkfive_active_products.dart';
import 'package:linkfive_purchases/models/linkfive_plan.dart';
import 'package:linkfive_purchases/models/linkfive_products.dart';
import 'package:linkfive_purchases/models/linkfive_restore_apple_item.dart';
import 'package:linkfive_purchases/models/linkfive_restore_google_item.dart';
import 'package:linkfive_purchases/store/linkfive_prefs.dart';
import 'package:linkfive_purchases/store/linkfive_store.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';

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
  ///
  /// Used for all internal LinkFive Requests
  LinkFiveClient _client = LinkFiveClient();

  /// Billing Client to Store
  ///
  /// Used for all interactions with the native billing client
  LinkFiveBillingClient _billingClient = LinkFiveBillingClient();

  /// Internal memory Storage for all products and responses
  LinkFiveStore _store = LinkFiveStore();

  /// Settings data memory storage
  ///
  /// We store the api key etc only in memory
  LinkFiveAppDataStore appDataStore = LinkFiveAppDataStore();

  StreamSubscription<List<PurchaseDetails>>? _purchaseStream;

  /// All available Products you can offer for purchase to your users
  ///
  /// @return a Stream of all available products.
  ///   null means that we do not have any data yet
  ///   empty array: we got data but didn't find any subscriptions
  Stream<LinkFiveProducts> get products => _store.productsStream;

  /// All active Products the user purchased
  Stream<LinkFiveActiveProducts> get activeProducts =>
      _store.activeProductsStream;

  //#endregion Members

  /// Initialize the LinkFive client with .init(...)
  /// This will check all active Subscriptions
  /// [apiKey] get your API Key in the API section of LinkFive
  /// [logLevel] default is DEBUG. Possible values are TRACE, DEBUG, INFO, WARN, ERROR
  /// [env] default is Production. Sets the LinkFive Environment.
  Future<LinkFiveActiveProducts> init(String apiKey,
      {LinkFiveLogLevel logLevel = LinkFiveLogLevel.DEBUG,
      LinkFiveEnvironment env = LinkFiveEnvironment.PRODUCTION}) async {
    if (appDataStore.apiKey.isNotEmpty) {
      LinkFiveLogger.d(
          "LinkFive is already Initialized. Please only call init once");
      return _store.latestLinkFiveActiveProducts ?? LinkFiveActiveProducts();
    }
    LinkFiveLogger.setLogLevel(logLevel);

    // init Preferences
    // does nothing else than putting the shared preference instance in place
    await LinkFivePrefs().init();

    // LinkFive User Management
    // also loads the saved LinkFive User ID if available
    await LinkFiveUserManagement().init();

    // save api Key in memory
    appDataStore.apiKey = apiKey;

    // init the client http client. sets the url etc.
    _client.init(env, appDataStore);

    LinkFiveLogger.d("init LinkFive");

    // initialize the native billing client.
    _billingClient.init(_client);

    // main method for purchases.
    // if a purchase was made, we get an update
    _listenPurchaseUpdates();

    // if not initialized yet, load all active subs and send to LinkFive
    // if (!(await LinkFivePrefs().hasInitialized)) {
    // await _loadActiveSubs();
    // } else {
    // Check LinkFive For Active Plans
    return await _updateActivePlansFromLinkFive();
    // }
  }

  /// Fetches the subscriptions from LinkFive and retrieves the IAP from the platform
  ///
  /// It also submits the ProductDetails to the LinkFive Stream
  ///
  /// @return [LinkFiveSubscriptionData] or null if no subscriptions found
  Future<LinkFiveProducts?> fetchProducts() async {
    LinkFiveLogger.d("fetch subscriptions");
    var linkFiveResponse = await _client.fetchLinkFiveResponse();
    _store.onNewResponseData(linkFiveResponse);

    List<ProductDetails>? platformSubscriptions =
        await _billingClient.getPlatformSubscriptions(linkFiveResponse);
    if (platformSubscriptions != null) {
      return _store.onNewPlatformSubscriptions(platformSubscriptions);
    }
    return null;
  }

  /// Make a purchase
  ///
  /// If you want to know if the purchase is pending, listen to listenOnPendingPurchase
  ///
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
  /// all made purchases
  @override
  Future<bool> restore() async {
    super.isPendingPurchase = true;
    await InAppPurchase.instance.restorePurchases();
    return false;
  }

  /// Handles the Up and Downgrade of a Subscription plans
  ///
  /// [oldPurchaseDetails] given by the LinkFive Plugin
  ///
  /// You can pass linkFiveProductDetails or productDetails. But one must be present.
  ///
  /// [linkFiveProductDetails]
  /// [productDetails] from the purchases you want to switch to
  /// [prorationMode] Google Only: default replaces immediately the subscription, and the remaining time will be prorated and credited to the user.
  ///   Check https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.ProrationMode for more information
  Future<bool> switchPlan(
      LinkFivePlan oldLinkFivePlan, LinkFiveProductDetails productDetails,
      {ProrationMode? prorationMode}) async {
    if (Platform.isAndroid) {
      return handleAndroidSwitchPlan(oldLinkFivePlan, productDetails,
          prorationMode: prorationMode);
    }
    if (Platform.isIOS) {
      return handleIosSwitchPlan(productDetails);
    }
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

  /// This method will load all active subs
  /// and call linkfive to submit all loaded
  /// this will probably be deprecated?
  _loadActiveSubs() async {
    LinkFiveLogger.d("load active subs from Store");
/*
    // get all receipts from the native client
    final verifiedReceiptsList = await billingClient.verifiedReceipts;
    LinkFiveLogger.d("loaded active subs from Store");
    // update listeners
    store.onNewLinkFiveActivePlanList(
        LinkFiveActiveSubscriptionData(verifiedReceiptsList));
    if (verifiedReceiptsList.length > 0) {
      super.purchaseState = PurchaseState.PURCHASED;
    } else {
      super.purchaseState = PurchaseState.NOT_PURCHASED;
    }*/
  }

  ///
  /// This Method will fetch all active plans from LinkFive,
  /// notify all listeners and return the instance
  Future<LinkFiveActiveProducts> _updateActivePlansFromLinkFive() async {
    LinkFiveLogger.d("Update active plans from LinkFive");
    try {
      // Fetch all Plans from LinkFive
      final List<LinkFivePlan> linkFivePlanList =
          await _client.fetchUserPlanListFromLinkFive();

      // notify all listeners
      final activeProducts =
          _store.onNewLinkFiveNewActivePlanList(linkFivePlanList);

      // return with the created object
      return activeProducts;
    } catch (e) {
      LinkFiveLogger.e("Error while fetching User Data: $e");
    }

    // return an empty List on error
    return LinkFiveActiveProducts();
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
  ///
  /// This method is getting called whenever there is a purchase update
  ///
  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    LinkFiveLogger.d(
        "Purchase Update with ${purchaseDetailsList.map((e) => "${e.status} ${e.productID} ${e.purchaseID}")}");
    if (purchaseDetailsList.isEmpty) {
      super.isPendingPurchase = false;
      return;
    }

    // instead of calling the api a thousand times for each restored purchase
    // we will collect all restored items and then call the api just once
    bool hasRestoredPurchases = false;

    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          LinkFiveLogger.d("_showPendingUI();");
          // We set pending purchase to true
          // This is only to show a loading indicator in the app
          super.isPendingPurchase = true;
          break;
        case PurchaseStatus.error:
          LinkFiveLogger.e("_handleError(purchaseDetails.error!)");
          break;
        case PurchaseStatus.canceled:
          LinkFiveLogger.e("_handleError(purchaseDetails.canceled!)");
          break;
        case PurchaseStatus.purchased:
          final _productDetails = _productDetailsToPurchase;
          _productDetailsToPurchase = null;

          // handle ios Purchase
          if (Platform.isIOS && _productDetails != null) {
            final appstorePurchaseDetails =
                purchaseDetails as AppStorePurchaseDetails;

            // handle the ios purchase request to LinkFive
            await _handlePurchaseApple(
                appstorePurchaseDetails, _productDetails);
          }
          // Handle google play purchase
          if (purchaseDetails is GooglePlayPurchaseDetails) {
            await _handlePurchaseGoogle(purchaseDetails);
          }

          break;
        case PurchaseStatus.restored:
          hasRestoredPurchases = true;
          break;
      }
    }

    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.pendingCompletePurchase) {
        // always on ios. android can be done locally or on server
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
    if (hasRestoredPurchases) {
      // Whenever the user clicks on restore, all purchases will be delivered
      // we call LinkFive just once instead of for each restored item
      await _handleRestore(purchaseDetailsList);
    }
    super.isPendingPurchase = false;
  }

  /// This will handle the restore functionality
  ///
  /// we will send all transactions to LinkFive and connect them to the
  /// current user
  _handleRestore(List<PurchaseDetails> purchaseDetailsList) async {
    List<LinkFivePlan> restoredPlans = [];

    // handle each platform separately
    if (Platform.isIOS) {
      restoredPlans = await _handleRestoreApple(purchaseDetailsList);
    } else if (Platform.isAndroid) {
      restoredPlans = await _handleRestoreGoogle(purchaseDetailsList);
    }
    // notify all listeners
    _store.onNewLinkFiveNewActivePlanList(restoredPlans);
  }

  Future<List<LinkFivePlan>> _handleRestoreApple(
      List<PurchaseDetails> purchaseDetailsList) async {
    final List<LinkFiveRestoreAppleItem> restoredTransactionList = [];

    // check each item if it is not null and save the transactionId
    for (PurchaseDetails pd in purchaseDetailsList) {
      final String? transactionId = pd.purchaseID;
      // just add to request if there is an actual transactionId
      if (transactionId != null && transactionId.isNotEmpty) {
        // get the originalTransactionId if it exists
        String? originalTransactionId;
        if (pd is AppStorePurchaseDetails) {
          originalTransactionId = pd
              .skPaymentTransaction.originalTransaction?.transactionIdentifier;
        }
        restoredTransactionList.add(LinkFiveRestoreAppleItem(
            transactionId: transactionId,
            originalTransactionId: originalTransactionId));
      }
    }

    // if the list is > 0 do the LinkFive request
    if (restoredTransactionList.length > 0) {
      return await _client.restoreIos(restoredTransactionList);
    }
    return [];
  }

  /// This will handle the Google restore functionality
  ///
  /// we will send all transactions to LinkFive and connect them to the
  /// current user
  ///
  /// @return empty list if there is no subscription
  ///
  Future<List<LinkFivePlan>> _handleRestoreGoogle(
      List<PurchaseDetails> purchaseDetailsList) async {
    final List<LinkFiveRestoreGoogleItem> restoredList = [];

    // check each item if it is not null and save the purchaseID
    for (PurchaseDetails pd in purchaseDetailsList) {
      String? originalTransactionId;
      if (pd is GooglePlayPurchaseDetails) {
        final sku = pd.billingClientPurchase.sku;
        final purchaseId = pd.billingClientPurchase.orderId;
        final purchaseToken = pd.billingClientPurchase.purchaseToken;
        restoredList.add(LinkFiveRestoreGoogleItem(
            sku: sku, purchaseId: purchaseId, purchaseToken: purchaseToken));
      }
    }

    // if the list is > 0 do the LinkFive request
    if (restoredList.length > 0) {
      return await _client.restoreGoogle(restoredList);
    }
    return [];
  }

  ///
  /// This will handle the apple purchase process and update all listeners
  ///
  _handlePurchaseApple(AppStorePurchaseDetails appstorePurchaseDetails,
      AppStoreProductDetails productDetailsToPurchase) async {
    List<LinkFivePlan> linkFivePlanList = await _client.purchaseIos(
        productDetailsToPurchase, appstorePurchaseDetails);

    // notify all listeners
    _store.onNewLinkFiveNewActivePlanList(linkFivePlanList);
  }

  ///
  /// This will handle the Google Play purchase process and update all listeners
  ///
  _handlePurchaseGoogle(GooglePlayPurchaseDetails purchaseDetails) async {
    List<LinkFivePlan> linkFivePlanList =
        await _client.purchaseGooglePlay(purchaseDetails);

    // notify all listeners
    _store.onNewLinkFiveNewActivePlanList(linkFivePlanList);
  }

  /// This method overrides the interface to fetch the subscriptions on view.
  @override
  Future<bool> loadSubscriptions() async {
    await fetchProducts();
    return true;
  }
//#endregion private methods
}
