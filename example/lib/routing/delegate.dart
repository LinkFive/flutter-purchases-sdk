import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:linkfive_purchases_example/page/bloc/bloc_paywall_page.dart';
import 'package:linkfive_purchases_example/page/provider/provider_simple_paywall_page.dart';
import 'package:linkfive_purchases_example/page/raw_page.dart';
import 'package:linkfive_purchases_example/root_page.dart';
import 'package:linkfive_purchases_example/routing/app_path.dart';
import 'package:linkfive_purchases_example/routing/no_animation_transition_delegate.dart';

class MainRouterDelegate extends RouterDelegate<AppPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppPath> {
  final GlobalKey<NavigatorState> navigatorKey;

  bool isRawPaywall = false;
  bool isSimplePaywall = false;
  int blocPage = 0;

  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppPath get currentConfiguration =>
      isSimplePaywall ? AppPath.home() : AppPath.simplePaywall();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        RootPage(),
        if (isRawPaywall) RawPage(),
        if (isSimplePaywall) ProviderSimplePaywallPage()
        else if(blocPage > 0) BlocPaywallPage(blocPage),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (isSimplePaywall) {
          isSimplePaywall = false;
        }
        if(blocPage > 0){
          blocPage = 0;
        }
        if (isRawPaywall) {
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
    if (configuration.isBlocPage) {
      blocPage = configuration.blocPage;
    }
  }

  goToRawPayWall() {
    isRawPaywall = true;
    notifyListeners();
  }

  goToProviderSimplePayWall() {
    isSimplePaywall = true;
    notifyListeners();
  }

  goToBlocRaw() {
    blocPage = 1;
    notifyListeners();
  }
  goToBlocUI() {
    blocPage = 2;
    notifyListeners();
  }

}
