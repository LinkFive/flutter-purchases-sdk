class AppPath {
  bool _isRawPaywall = false;
  bool _isSimplePaywall = false;
  bool _isMoritzPaywall = false;

  AppPath.home() : _isSimplePaywall = false;
  AppPath.rawPaywall() : _isRawPaywall = true;
  AppPath.simplePaywall() : _isSimplePaywall = true;
  AppPath.moritzPaywall() : _isMoritzPaywall = true;

  bool get isHomePage => !_isRawPaywall && !_isSimplePaywall && !_isMoritzPaywall;

  bool get isSimplePaywallPage => _isSimplePaywall;
  bool get isRawPaywallPage => _isRawPaywall;
  bool get isMoritzPaywallPage => _isMoritzPaywall;
}
