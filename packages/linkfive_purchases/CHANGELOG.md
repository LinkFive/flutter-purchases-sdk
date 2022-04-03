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
