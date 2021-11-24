import 'dart:async';

import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';
import 'package:in_app_purchases_interface/in_app_purchases_interface.dart';
import 'package:linkfive_purchases/models/linkfive_active_subscription.dart';
import 'package:linkfive_purchases/models/linkfive_response.dart';
import 'package:linkfive_purchases/models/linkfive_subscription.dart';

/// Data holder for API related calls
/// includes all Streams for the sdk
class LinkFiveStore {
  LinkFiveResponseData? latestLinkFiveResponse;
  List<ProductDetails>? latestProductDetailList;
  LinkFiveSubscriptionData? latestLinkFiveSubscriptionData;

  LinkFiveActiveSubscriptionData? latestLinkFiveActiveSubscriptionData;

  // Stream to flutter of Raw Response
  static List<StreamController<LinkFiveResponseData?>>
      _streamControllerResponse = [];
  static List<StreamController<LinkFiveSubscriptionData?>>
      _streamControllerSubscriptions = [];
  static List<StreamController<LinkFiveActiveSubscriptionData?>>
      _streamControllerActiveSubscriptions = [];

  Stream<LinkFiveResponseData?> listenOnResponseData() {
    var controller = StreamController<LinkFiveResponseData?>();
    _streamControllerResponse.add(controller);
    if (latestLinkFiveResponse != null) {
      LinkFiveLogger.d("push response data after create");
      controller.add(latestLinkFiveResponse);
    }
    return controller.stream;
  }

  Stream<LinkFiveSubscriptionData?> listenOnSubscriptionData() {
    var controller = StreamController<LinkFiveSubscriptionData?>();
    _streamControllerSubscriptions.add(controller);
    if (latestProductDetailList != null) {
      LinkFiveLogger.d("push sub data after create");
      controller.add(latestLinkFiveSubscriptionData);
    }
    return controller.stream;
  }

  Stream<LinkFiveActiveSubscriptionData?> listenOnActiveSubscriptionData() {
    var controller = StreamController<LinkFiveActiveSubscriptionData?>();
    _streamControllerActiveSubscriptions.add(controller);
    if (latestLinkFiveActiveSubscriptionData != null) {
      LinkFiveLogger.d("push sub data after create");
      controller.add(latestLinkFiveActiveSubscriptionData);
    }
    return controller.stream;
  }

  onNewResponseData(LinkFiveResponseData data) {
    latestLinkFiveResponse = data;
    LinkFiveLogger.d("new response $data");
    _cleanAllStreams();
    _streamControllerResponse.forEach((element) {
      LinkFiveLogger.d(
          "push response data with skus: ${data.subscriptionList.map((e) => e.sku)}");
      element.add(data);
    });
  }

  ///
  /// Whenever new subscriptions are loaded, we save it in a [LinkFiveSubscriptionData]
  ///
  LinkFiveSubscriptionData? onNewPlatformSubscriptions(
      List<ProductDetails> platformSubscriptions) {
    latestProductDetailList = platformSubscriptions;
    latestLinkFiveSubscriptionData = LinkFiveSubscriptionData(
        platformSubscriptions.map((pd) => LinkFiveProductDetails(pd)).toList(),
        latestLinkFiveResponse?.attributes,
        null);

    _cleanAllStreams();

    _streamControllerSubscriptions.forEach((element) {
      LinkFiveLogger.d(
          "push sub data with ids ${latestLinkFiveSubscriptionData?.linkFiveSkuData.map((e) => e.productDetails.id)}");
      element.add(latestLinkFiveSubscriptionData);
    });
    return latestLinkFiveSubscriptionData;
  }

  onNewLinkFiveActiveSubDetails(
      LinkFiveActiveSubscriptionData linkFiveActiveSubscriptionData) {
    latestLinkFiveActiveSubscriptionData = linkFiveActiveSubscriptionData;

    // notify observer
    _cleanAllStreams();
    _streamControllerActiveSubscriptions.forEach((element) {
      LinkFiveLogger.d(
          "push active sub data with size ${latestLinkFiveActiveSubscriptionData?.subscriptionList.length ?? 0}");
      element.add(latestLinkFiveActiveSubscriptionData);
    });
  }

  _cleanAllStreams() {
    _cleanStream(_streamControllerResponse);
    _cleanStream(_streamControllerSubscriptions);
    _cleanStream(_streamControllerActiveSubscriptions);
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
