## 2.0.0-dev.1

Pre-Release of LinkFive 2.0 The changelog is following soon

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
