import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:linkfive_purchases/client/linkfive_billing_client_interface.dart';
import 'package:linkfive_purchases/client/linkfive_client_interface.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import './linkfive_purchases_main_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<InAppPurchase>(unsupportedMembers: {#getPlatformAddition}),
  MockSpec<LinkFiveClientInterface>(returnNullOnMissingStub: true),
  MockSpec<LinkFiveBillingClientInterface>(returnNullOnMissingStub: true)
])
void main() {
  group("General Test Purchases Main", () {
    // init mock purchase instances
    final inAppPurchaseInstance = MockInAppPurchase();
    final mockLinkFiveClient = MockLinkFiveClientInterface();
    final mockLinkFiveBillingClient = MockLinkFiveBillingClientInterface();

    // set shared pref mock data to empty
    SharedPreferences.setMockInitialValues({});

    // mock the purchaseStream
    const purchaseStream = Stream<List<PurchaseDetails>>.empty();

    when(inAppPurchaseInstance.purchaseStream)
        .thenAnswer((_) => purchaseStream);

    when(mockLinkFiveClient.fetchLinkFiveResponse()).thenAnswer(
        (realInvocation) async => LinkFiveResponseData("", "", List.empty()));

    when(mockLinkFiveBillingClient.getPlatformSubscriptions(any))
        .thenAnswer((realInvocation) async => null);

    test('Test FetchProducts to await until initialized', () async {
      final linkFivePurchases = LinkFivePurchasesImpl.testing(
          inAppPurchaseInstance: inAppPurchaseInstance,
          linkFiveClient: mockLinkFiveClient,
          linkFiveBillingClient: mockLinkFiveBillingClient);

      // call fetchProducts before Init
      var asyncProduct = linkFivePurchases.fetchProducts();
      var asyncInit = linkFivePurchases.init("api-key");

      // verify that we did not call the fetch command yet.
      verifyNever(mockLinkFiveClient.fetchLinkFiveResponse());

      await asyncInit;
      // At this point, the init is done.
      // let's check if the response has not been fetched yet.

      verifyNever(mockLinkFiveClient.fetchLinkFiveResponse());
      expect(linkFivePurchases.isInitialized.isCompleted, true);

      // now wait for the product future and chekc if response has been called

      await asyncProduct;
      verify(mockLinkFiveClient.fetchLinkFiveResponse()).called(1);
    });

    test('Test API key is using test client', () async {
      final linkFivePurchases = LinkFivePurchasesImpl.testing(
          inAppPurchaseInstance: inAppPurchaseInstance);
      await linkFivePurchases.init(LinkFiveAppDataStore.TEST_KEY);
      expect(linkFivePurchases.isTestClient, true);
      expect(linkFivePurchases.isTestBillingClient, true);
    });

    test('Test API key is NOT using test client', () async {
      final linkFivePurchases = LinkFivePurchasesImpl.testing(
          inAppPurchaseInstance: inAppPurchaseInstance);
      await linkFivePurchases.init("abcdef");
      expect(linkFivePurchases.isTestClient, false);
      expect(linkFivePurchases.isTestBillingClient, false);
    });
  });
}
