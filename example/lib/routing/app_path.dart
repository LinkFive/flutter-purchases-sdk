class AppPath {
  bool _isRawPaywall = false;
  bool _isSimplePaywall = false;
  int blocPage = 0;

  AppPath.home() : _isSimplePaywall = false;
  AppPath.rawPaywall() : _isRawPaywall = true;
  AppPath.simplePaywall() : _isSimplePaywall = true;
  AppPath.blocPageRaw() : blocPage = 1;
  AppPath.blocPageUI() : blocPage = 2;

  bool get isHomePage => !_isRawPaywall && !_isSimplePaywall && blocPage != 0;

  bool get isSimplePaywallPage => _isSimplePaywall;
  bool get isRawPaywallPage => _isRawPaywall;
  bool get isBlocPage => blocPage > 0;
}
