import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases_example/page/raw_page.dart';
import 'package:linkfive_purchases_example/page/simple_paywall_ui_page.dart';
import 'package:linkfive_purchases_example/root_page.dart';
import 'package:linkfive_purchases_example/routing/app_path.dart';
import 'package:linkfive_purchases_example/routing/no_animation_transition_delegate.dart';

class MainRouterDelegate extends RouterDelegate<AppPath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppPath> {
  final GlobalKey<NavigatorState> navigatorKey;

  bool isRawPaywall = false;
  bool isSimplePaywall = false;

  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppPath get currentConfiguration => isSimplePaywall ? AppPath.home() : AppPath.simplePaywall();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        RootPage(),
        if (isRawPaywall) RawPage(),
        if (isSimplePaywall) SimplePayWallUiPage(),
        //if (_selectedRecipeId != null) RecipeDetailPage(_selectedRecipeId!)
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (isSimplePaywall) {
          isSimplePaywall = false;
        }
        if(isRawPaywall){
          isRawPaywall = false;
        }
        notifyListeners();

        return true;
      },
    );
  }

  @override
  setNewRoutePath(AppPath configuration) async {
    if (configuration.isRawPaywallPage) {
      isRawPaywall = true;
    }
    if (configuration.isSimplePaywallPage) {
      isSimplePaywall = true;
    }
  }

  goToRawPayWall() {
    isRawPaywall = true;
    notifyListeners();
  }

  goToSimplePayWall() {
    isSimplePaywall = true;
    LinkFivePurchases.fetchSubscriptions();
    notifyListeners();
  }
}
