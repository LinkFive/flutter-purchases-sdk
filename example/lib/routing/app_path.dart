class AppPath {
  bool _isRawPaywall = false;
  bool _isSimplePaywall = false;

  AppPath.home() : _isSimplePaywall = false;
  AppPath.rawPaywall(): _isRawPaywall = true;
  AppPath.simplePaywall(): _isSimplePaywall = true;

  bool get isHomePage => !_isRawPaywall && !_isSimplePaywall;

  bool get isSimplePaywallPage => _isSimplePaywall;
  bool get isRawPaywallPage => _isRawPaywall;
}