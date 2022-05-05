import 'package:linkfive_purchases/store/linkfive_prefs.dart';

/// Model to store some sdk data
class LinkFiveAppDataStore {
  String apiKey = "";
  String? utmSource = null;
  String? _userId = null;
  String? environment = null;

  String? get userId => _userId;

  set userId(value) {
    this._userId = value;
    LinkFivePrefs().userId = value;
  }

  init(String apiKey) async {
    this.apiKey = apiKey;
    _userId = LinkFivePrefs().userId;
  }
}
