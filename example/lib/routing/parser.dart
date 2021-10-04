import 'package:flutter/cupertino.dart';
import 'package:linkfive_purchases_example/routing/app_path.dart';

class AppPathInformationParser extends RouteInformationParser<AppPath> {
  @override
  Future<AppPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case "simplePaywall":
          return AppPath.simplePaywall();
      }
    }
    return AppPath.home();
  }

  @override
  RouteInformation? restoreRouteInformation(AppPath path) {
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isSimplePaywallPage) {
      return RouteInformation(location: '/simplePaywall');
    }
    return null;
  }
}
