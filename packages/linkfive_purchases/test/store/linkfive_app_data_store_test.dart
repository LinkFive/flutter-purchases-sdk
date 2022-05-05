// Import the test package and Counter class
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';
import 'package:linkfive_purchases/store/linkfive_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  test('Store UserId on both, AppDataStore and Prefs', () async {
    LinkFivePrefs linkFivePrefs = LinkFivePrefs();
    LinkFiveAppDataStore linkFiveAppDataStore = LinkFiveAppDataStore();

    SharedPreferences.setMockInitialValues({});

    await linkFivePrefs.init();

    linkFiveAppDataStore.userId = "LinkFive";

    expect(linkFivePrefs.userId, "LinkFive");
    expect(linkFiveAppDataStore.userId, "LinkFive");

    linkFiveAppDataStore.userId = null;

    expect(linkFivePrefs.userId, null);
    expect(linkFiveAppDataStore.userId, null);
  });
}
