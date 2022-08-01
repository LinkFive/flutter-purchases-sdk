import 'package:linkfive_purchases/store/linkfive_prefs.dart';

/// Model to store some sdk data
class LinkFiveAppDataStore {

  static String TEST_KEY = "TmljZSAyIG1lZXQgeW91IE1yLkhhY2tlcg=";

  String apiKey = "";
  String? utmSource;
  String? _userId;
  String? environment;

  String? get userId => _userId;

  set userId(value) {
    this._userId = value;
    LinkFivePrefs().userId = value;
  }

  init(String apiKey) async {
    this.apiKey = apiKey;
    _userId = LinkFivePrefs().userId;
  }

  /// True if the testKey was used
  bool get isTestKey => apiKey == TEST_KEY;
}
