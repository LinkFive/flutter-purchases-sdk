import 'package:linkfive_purchases/models/requests/purchase_request_google.dart';
import 'package:linkfive_purchases/models/requests/purchase_request_pricing_phase.dart';
import 'package:test/test.dart';

void main() {
  group("Purchase Request Google Test", () {
    test('Test toJson Converter', () {
      const objectToTest = PurchaseRequestGoogle(
          sku: "sku",
          purchaseId: "purchaseId",
          purchaseToken: "purchaseToken",
          basePlanId: "basePlanId",
          purchaseRequestPricingPhaseList: [PurchaseRequestPricingPhase(1, "P1Y", "finiteRecurring")]);

      final jsobObject = objectToTest.toJson();
      expect(jsobObject["sku"], "sku");
      expect(jsobObject["purchaseRequestPricingPhaseList"], [{"billingCycleCount":1,"billingPeriod":"P1Y","recurrence":"finiteRecurring"}]);
    });
  });
}
