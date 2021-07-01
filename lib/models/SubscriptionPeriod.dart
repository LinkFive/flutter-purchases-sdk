
import 'package:in_app_purchase_ios/src/store_kit_wrappers/sk_product_wrapper.dart';

enum SubscriptionPeriod{
  P1Y, P6M, P3M, P1M, P1W,
}

class SubscriptionPeriodUtil {
  static SubscriptionPeriod? fromGoogle(String period){
    switch (period){
      case "P1Y":return SubscriptionPeriod.P1Y;
      case "P6M":return SubscriptionPeriod.P6M;
      case "P3M":return SubscriptionPeriod.P3M;
      case "P1M":return SubscriptionPeriod.P1M;
      case "P1W":return SubscriptionPeriod.P1W;
    }
    return null;
  }
  static SubscriptionPeriod? fromAppStore(SKProductSubscriptionPeriodWrapper? subscriptionPeriod){
    if(subscriptionPeriod == null){
      return null;
    }
    if(subscriptionPeriod.unit == SKSubscriptionPeriodUnit.year){
      return SubscriptionPeriod.P1Y;
    }
    if(subscriptionPeriod.unit == SKSubscriptionPeriodUnit.month){
      if(subscriptionPeriod.numberOfUnits == 6){
        return SubscriptionPeriod.P6M;
      }
      if(subscriptionPeriod.numberOfUnits == 3){
        return SubscriptionPeriod.P3M;
      }
      if(subscriptionPeriod.numberOfUnits == 1){
        return SubscriptionPeriod.P1M;
      }
    }
    if(subscriptionPeriod.unit == SKSubscriptionPeriodUnit.week){
      return SubscriptionPeriod.P1W;
    }

    return SubscriptionPeriod.P1M;
  }
}