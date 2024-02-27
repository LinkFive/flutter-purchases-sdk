import 'dart:async';

import 'package:linkfive_purchases/linkfive_purchases.dart';

///
/// Default Purchase Handler
///
/// [LinkFivePurchasesMain] extends this class to control the state of a purchase
///
class DefaultPurchaseHandler implements PurchaseStateStreamInterface {
  /// initial value for purchase in Progress
  final bool initialIsPurchaseInProgress;

  /// initial value for purchase Success
  final PurchaseState initialPurchaseState;

  /// Pending Purchase Cached data
  late bool _isPendingPurchase;

  /// Pending Purchase Cached data
  late PurchaseState _purchaseState;

  /// used to fetch the subscriptions at least once when the page
  /// opens and the purchase state is NOT_PURCHASED
  bool _loadedSubscriptionsOnce = false;

  DefaultPurchaseHandler(
      {this.initialIsPurchaseInProgress = false,
      this.initialPurchaseState = PurchaseState.NOT_PURCHASED}) {
    _isPendingPurchase = initialIsPurchaseInProgress;
    _purchaseState = initialPurchaseState;
  }

  //#region Pending Purchase
  /// StreamController list of Pending Purchase Streams
  final List<StreamController<bool>> _streamControllerPendingPurchase = [];

  /// Sets the value and updates all Stream listeners
  ///
  /// Also cleans all unused streams
  set isPendingPurchase(bool value) {
    LinkFiveLogger.d("set pending purchase to $value");
    _isPendingPurchase = value;

    // Clean streams
    _cleanStreams(_streamControllerPendingPurchase);
    // send data to stream
    for (var element in _streamControllerPendingPurchase) {
      if (element.hasListener) {
        element.add(_isPendingPurchase);
      }
    }
  }

  bool get isPendingPurchase => _isPendingPurchase;

  //#endregion

  //#region PurchaseState
  /// StreamController list of Pending Purchase Streams
  final List<StreamController<PurchaseState>> _streamControllerPurchaseState = [];

  /// Sets the value and updates all Stream listeners
  ///
  /// Also cleans all unused streams
  set purchaseState(PurchaseState value) {
    LinkFiveLogger.d("set purchaseState value $value");
    _purchaseState = value;

    // Clean streams
    _cleanStreams(_streamControllerPurchaseState);

    // send data to stream
    for (var element in _streamControllerPurchaseState) {
      if (element.hasListener) {
        element.add(_purchaseState);
      }
    }
  }

  //#endregion

  ///
  /// Whenever the plugin receives a new active Products we will update the state
  /// to either
  ///
  /// PURCHASED
  ///   or
  /// NOT_PURCHASED
  ///
  updateStateFromActiveProducts(LinkFiveActiveProducts activeProducts) {
    if (activeProducts.isNotEmpty) {
      purchaseState = PurchaseState.PURCHASED;
    } else {
      purchaseState = PurchaseState.NOT_PURCHASED;
    }
  }

  @override
  Stream<bool> purchaseInProgressStream() {
    // clean streams
    _cleanStreams(_streamControllerPendingPurchase);
    // create new stream controller
    var controller = StreamController<bool>();
    _streamControllerPendingPurchase.add(controller);
    controller.add(_isPendingPurchase);
    _checkPurchaseStateAndLoad();
    return controller.stream;
  }

  /// Check if the purchase state is NOT_PURCHASED and if true
  /// call too loadSubscriptions
  void _checkPurchaseStateAndLoad() async {
    if (_purchaseState == PurchaseState.NOT_PURCHASED) {
      if (!_loadedSubscriptionsOnce) {
        bool success = await loadSubscriptions();
        // if the subscription loaded successful, make sure to not call
        // it again to avoid looping behaviour
        if (success) {
          _loadedSubscriptionsOnce = true;
        }
      }
    }
  }

  @override
  Stream<PurchaseState> purchaseStateStream() {
    // clean streams
    _cleanStreams(_streamControllerPurchaseState);
    // create new stream controller
    var controller = StreamController<PurchaseState>();
    _streamControllerPurchaseState.add(controller);
    controller.add(_purchaseState);
    return controller.stream;
  }

  void _cleanStreams(List<StreamController> streams) {
    streams.removeWhere((element) {
      return element.isClosed;
    });
  }

  /// Reload the subscriptions
  /// This will be overwritten by LinkFivePurchasesMain
  @override
  Future<bool> loadSubscriptions() async {
    LinkFiveLogger.d("You should load your store subscriptions now");
    return false;
  }
}
