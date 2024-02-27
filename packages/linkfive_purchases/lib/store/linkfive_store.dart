import 'dart:async';

import 'package:linkfive_purchases/linkfive_purchases.dart';

/// Data holder for API related calls
/// includes all Streams for the sdk
class LinkFiveStore {
  /// Raw Data Response from LinkFive
  LinkFiveResponseData? latestLinkFiveResponse;

  /// Latest Product details we got from the Store
  List<ProductDetails>? latestProductDetailList;

  /// These are the latest valid products we can offer to the user
  LinkFiveProducts? latestLinkFiveProducts;

  /// These are the latest valid and active Products we got from LinkFive
  LinkFiveActiveProducts? latestLinkFiveActiveProducts;

  static final List<StreamController<LinkFiveProducts>> _streamControllerProducts = [];
  static final List<StreamController<LinkFiveActiveProducts>> _streamControllerActiveProducts = [];

  /// Creates a new Stream and adds it to the stream controller
  ///
  /// Return the just created stream
  Stream<LinkFiveProducts> get productsStream {
    var controller = StreamController<LinkFiveProducts>();
    _streamControllerProducts.add(controller);
    final products = latestLinkFiveProducts;
    if (products != null) {
      LinkFiveLogger.d("push sub products data after create");
      controller.add(products);
    }
    return controller.stream;
  }

  /// Creates a new Stream and adds it to the stream controller
  ///
  /// Return the just created stream
  Stream<LinkFiveActiveProducts> get activeProductsStream {
    var controller = StreamController<LinkFiveActiveProducts>();
    _streamControllerActiveProducts.add(controller);
    final activeProducts = latestLinkFiveActiveProducts;
    if (activeProducts != null) {
      LinkFiveLogger.d("push sub activeProducts data after create");
      controller.add(activeProducts);
    }
    return controller.stream;
  }

  /// Just saves the response from LinkFive
  void onNewResponseData(LinkFiveResponseData data) {
    latestLinkFiveResponse = data;
  }

  ///
  /// Whenever new product is loaded, we save it in a [LinkFiveSubscriptionData]
  ///
  LinkFiveProducts onNewPlatformProduct(List<ProductDetails> productDetailList) {
    // store the details in the latest property
    latestProductDetailList = productDetailList;

    // Create the LinkFive Products
    final linkFiveProducts = LinkFiveProducts(
        productDetailList: productDetailList.map((pd) => LinkFiveProductDetails(pd)).toList(),
        attributes: latestLinkFiveResponse?.attributes,
        error: null);

    // store it in the latestLinkFiveProducts
    latestLinkFiveProducts = linkFiveProducts;

    _cleanAllStreams();

    LinkFiveLogger.d(
        "push sub data with ids ${latestLinkFiveProducts?.productDetailList.map((e) => e.productDetails.id)}");

    for (var streamController in _streamControllerProducts) {
      streamController.add(linkFiveProducts);
    }
    return linkFiveProducts;
  }

  /// This method is the first entry point to notify all listeners that there
  /// are new plans available.
  LinkFiveActiveProducts onNewLinkFiveNewActiveProducts(LinkFiveActiveProducts activeProducts) {
    latestLinkFiveActiveProducts = activeProducts;

    _cleanAllStreams();

    // notify observer
    for (StreamController<LinkFiveActiveProducts> streamController in _streamControllerActiveProducts) {
      LinkFiveLogger.d("push active sub data with size ${activeProducts.planList.length}, otp size: ${activeProducts.oneTimePurchaseList.length}");
      streamController.add(activeProducts);
    }
    return activeProducts;
  }

  /// Cleans all streams
  ///
  /// This basically checks if a stream is still active and if not, it will be
  /// removed from the list
  _cleanAllStreams() {
    _cleanStream(_streamControllerProducts);
    _cleanStream(_streamControllerActiveProducts);
  }

  _cleanStream(List<StreamController> streamControllerList) {
    streamControllerList.removeWhere((element) {
      if (element.isClosed) {
        return true;
      }
      if (!element.hasListener) {
        return true;
      }
      return false;
    });
  }
}
