import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'linkfive_purchases_main_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<InAppPurchase>(unsupportedMembers: {#getPlatformAddition})
])
void main() {
  /// This test will fail if fetchProducts is not waiting until the end of the initialization
  test('Test Init linkfive async fetch', () async {
    SharedPreferences.setMockInitialValues({});
    final inAppPurchaseInstance = MockInAppPurchase();
    final purchaseStream = Stream<List<PurchaseDetails>>.empty();

    when(inAppPurchaseInstance.purchaseStream).thenAnswer((_) => purchaseStream);

    final linkFivePurchases = LinkFivePurchasesMain.testing(
        inAppPurchaseInstance: inAppPurchaseInstance);
    linkFivePurchases.fetchProducts();
    linkFivePurchases.init("api-key");
  });
}
