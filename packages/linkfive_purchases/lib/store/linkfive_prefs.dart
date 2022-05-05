import 'package:shared_preferences/shared_preferences.dart';

class LinkFivePrefs {
  LinkFivePrefs._();

  static LinkFivePrefs _instance = LinkFivePrefs._();

  factory LinkFivePrefs() => _instance;

  static const _prefix = "linkfive";

  static const _LAST_ACTIVE_PRODUCTS = "$_prefix.last.active.products";
  static const _LINKFIVE_UUID = "$_prefix.linkfive.uuid";
  static const _USERID = "$_prefix.userid";

  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// LinkFive is initialized if we have a LinkFive UUID
  bool get hasInitialized => linkFiveUUID != null;

  String? get lastActiveProducts => _prefs.getString(_LAST_ACTIVE_PRODUCTS);

  set lastPremium(value) => _prefs.setString(_LAST_ACTIVE_PRODUCTS, value);

  String? get linkFiveUUID => _prefs.getString(_LINKFIVE_UUID);

  set linkFiveUUID(String? value) =>
      value != null ? _prefs.setString(_LINKFIVE_UUID, value) : null;

  String? get userId => _prefs.getString(_USERID);

  set userId(value) {
    if (value == null) {
      _prefs.remove(_USERID);
    } else {
      _prefs.setString(_USERID, value);
    }
  }
}
