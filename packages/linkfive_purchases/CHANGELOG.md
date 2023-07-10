## 3.0.0-1.beta
Breaking Change Update.

* Flutter ^3.10 Update
* Dart ^3.0.0 Update
* We now support Google Play Base-Plans
* We updated the in_app_purchase flutter lib to latest
* There is a new `Period` class that holds a `PeriodUnit` and `amount` of units.
* We added the `PricingPhase` to Google Play Store and Apple App Store

## 2.1.3
* Update dependencies
* This will also fix the restore-bug on Android

## 2.1.2
* Make plugin compatible with pre Flutter 3.0

## 2.1.1
* Add Test API Key handling. Use "TmljZSAyIG1lZXQgeW91IE1yLkhhY2tlcg=" to quickly test this plugin but please do not use it more than just the initial testing.
* Added some more Unit tests.

## 2.1.0
* Update for Flutter ^3.0.0
* fetchProducts() now waits until the initialization is done. There is no need to await LinkFiveProducts.init(...) anymore.
* Update to in_app_purchase: 3.0.6
* We added more unit tests.


## 2.0.2
* We fixed a bug when setting the userID is not saved on the device.
* we also implemented all new dart analysis changes
* updated to flutter 2.10.4

## 2.0.1
* fixing PendingPurchase handler which tells the UI that the purchase is ongoing.
* We also now send the plugin version to LinkFive with each request
* update the Example project


## 2.0.0

Release of LinkFive 2.0

With this major release we are paving the way for flutter web subscriptions as well as other exciting features coming soon to LinkFive.

A subscription is now called a Plan to prepare for flutter web subscriptions and other recurring or time-framed plans like coupon plans, team plans, etc.

* `LinkFivePurchases.fetchSubscriptions();` is now `LinkFivePurchases.fetchProducts();`
* `LinkFiveSubscriptionData` is now `LinkFiveProducts` and they own a List of `LinkFiveProductDetails` for better understanding.
* `LinkFiveActiveSubscriptionData` is now `LinkFiveActiveProducts` and they own a List of `LinkFivePlan`.

A LinkFivePlan has a completely new body:

* String productId;
* String planId;
* String rootId;
* DateTime purchaseDate;
* DateTime endDate;
* String storeType;
* String? customerUserId;
* bool? isTrial;
* String? familyName;
* String? attributes;
* String? duration;

* Listen on purchase updates changes from `LinkFivePurchases.listenOnActiveSubscriptionData()` to `LinkFivePurchases.activeProducts` which is much simpler.

**Paywall UI Helper changes**

* `products.getSubscriptionData(context: context)`  is now `products.paywallUIHelperData(context: context)`

* LinkFivePurchases.init("API Key") now returns a Future<> which you should await before you fetch your products

## 1.5.0

Breaking change: fetchSubscriptions returns a Future<LinkFiveSubscriptionData?> instead of Future<List<ProductDetails>?>
> LinkFiveSubscriptionData has `List<LinkFiveProductDetails> linkFiveSkuData` which contains the productDetail.

* listenOnResponseData is now deprecated and won't be replaced.
* LinkFiveVerifiedReceipt now has subscriptionDuration which containts the duration of the subscription. P1W, P1M, P3M, P6M, P1Y
* Added some more documentation

## 1.4.0
Add Switch Plan functionality. You can now call LinkFivePurchases.switchPlan(...) to switch from one plan to another.
Add more documentation

## 1.3.0
update to interface 0.0.7
return a Future<List<ProductDetails>?> on fetchSubscriptions instead of a dynamics, thanks to king-louis-rds for the feedback!
added platform files again to satisfy pub.dev points (hopefully)

## 1.2.0
update to interface 0.0.6 
* It fetches the subscriptions on load call now
  update intl to 0.0.3
  removed the unused android folder
  Prepared the package for the new LinkFive provider package

## 1.1.1
remove unused dependencies

## 1.1.0
add easy paywall ui integration.
add provider example.
add streambuilder example.
add intl package.
add interface package

## 1.0.1
* fixed a bug where a purchase was not immediately processed as a purchase.  

## 1.0.0
* Initial and tested production release
