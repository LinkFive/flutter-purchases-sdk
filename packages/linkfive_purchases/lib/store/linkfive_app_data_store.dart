import 'package:linkfive_purchases/store/linkfive_prefs.dart';

/// Model to store some sdk data
class LinkFiveAppDataStore {
  String apiKey = "";
  String? utmSource = null;
  String? userId = null;
  String? environment = null;

  init(String apiKey) async {
    this.apiKey = apiKey;
    userId = LinkFivePrefs().userId;
  }
}
