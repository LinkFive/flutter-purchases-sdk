// Mocks generated by Mockito 5.4.4 from annotations
// in linkfive_purchases/test/logic/linkfive_purchases_main_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:in_app_purchase/in_app_purchase.dart' as _i4;
import 'package:in_app_purchase_android/in_app_purchase_android.dart' as _i10;
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart'
    as _i2;
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart' as _i9;
import 'package:linkfive_purchases/client/linkfive_billing_client_interface.dart'
    as _i11;
import 'package:linkfive_purchases/client/linkfive_client_interface.dart'
    as _i7;
import 'package:linkfive_purchases/linkfive_purchases.dart' as _i3;
import 'package:linkfive_purchases/store/linkfive_app_data_store.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeProductDetailsResponse_0 extends _i1.SmartFake
    implements _i2.ProductDetailsResponse {
  _FakeProductDetailsResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLinkFiveResponseData_1 extends _i1.SmartFake
    implements _i3.LinkFiveResponseData {
  _FakeLinkFiveResponseData_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLinkFiveActiveProducts_2 extends _i1.SmartFake
    implements _i3.LinkFiveActiveProducts {
  _FakeLinkFiveActiveProducts_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [InAppPurchase].
///
/// See the documentation for Mockito's code generation for more information.
class MockInAppPurchase extends _i1.Mock implements _i4.InAppPurchase {
  MockInAppPurchase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Stream<List<_i2.PurchaseDetails>> get purchaseStream =>
      (super.noSuchMethod(
        Invocation.getter(#purchaseStream),
        returnValue: _i5.Stream<List<_i2.PurchaseDetails>>.empty(),
      ) as _i5.Stream<List<_i2.PurchaseDetails>>);
  @override
  T getPlatformAddition<T extends _i2.InAppPurchasePlatformAddition?>() =>
      (super.noSuchMethod(
        Invocation.method(
          #getPlatformAddition,
          [],
        ),
        returnValue: _i6.dummyValue<T>(
          this,
          Invocation.method(
            #getPlatformAddition,
            [],
          ),
        ),
      ) as T);
  @override
  _i5.Future<bool> isAvailable() => (super.noSuchMethod(
        Invocation.method(
          #isAvailable,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<_i2.ProductDetailsResponse> queryProductDetails(
          Set<String>? identifiers) =>
      (super.noSuchMethod(
        Invocation.method(
          #queryProductDetails,
          [identifiers],
        ),
        returnValue: _i5.Future<_i2.ProductDetailsResponse>.value(
            _FakeProductDetailsResponse_0(
          this,
          Invocation.method(
            #queryProductDetails,
            [identifiers],
          ),
        )),
      ) as _i5.Future<_i2.ProductDetailsResponse>);
  @override
  _i5.Future<bool> buyNonConsumable(
          {required _i2.PurchaseParam? purchaseParam}) =>
      (super.noSuchMethod(
        Invocation.method(
          #buyNonConsumable,
          [],
          {#purchaseParam: purchaseParam},
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<bool> buyConsumable({
    required _i2.PurchaseParam? purchaseParam,
    bool? autoConsume = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #buyConsumable,
          [],
          {
            #purchaseParam: purchaseParam,
            #autoConsume: autoConsume,
          },
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<void> completePurchase(_i2.PurchaseDetails? purchase) =>
      (super.noSuchMethod(
        Invocation.method(
          #completePurchase,
          [purchase],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> restorePurchases({String? applicationUserName}) =>
      (super.noSuchMethod(
        Invocation.method(
          #restorePurchases,
          [],
          {#applicationUserName: applicationUserName},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [LinkFiveClientInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockLinkFiveClientInterface extends _i1.Mock
    implements _i7.LinkFiveClientInterface {
  @override
  dynamic init(
    _i3.LinkFiveEnvironment? env,
    _i8.LinkFiveAppDataStore? appDataStore,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #init,
          [
            env,
            appDataStore,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i5.Future<_i3.LinkFiveResponseData> fetchLinkFiveResponse() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchLinkFiveResponse,
          [],
        ),
        returnValue: _i5.Future<_i3.LinkFiveResponseData>.value(
            _FakeLinkFiveResponseData_1(
          this,
          Invocation.method(
            #fetchLinkFiveResponse,
            [],
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveResponseData>.value(
            _FakeLinkFiveResponseData_1(
          this,
          Invocation.method(
            #fetchLinkFiveResponse,
            [],
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveResponseData>);
  @override
  _i5.Future<_i3.LinkFiveActiveProducts> purchaseIos({
    required _i9.AppStoreProductDetails? productDetails,
    required _i9.AppStorePurchaseDetails? purchaseDetails,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #purchaseIos,
          [],
          {
            #productDetails: productDetails,
            #purchaseDetails: purchaseDetails,
          },
        ),
        returnValue: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #purchaseIos,
            [],
            {
              #productDetails: productDetails,
              #purchaseDetails: purchaseDetails,
            },
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #purchaseIos,
            [],
            {
              #productDetails: productDetails,
              #purchaseDetails: purchaseDetails,
            },
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveActiveProducts>);
  @override
  _i5.Future<_i3.LinkFiveActiveProducts> purchaseGooglePlay(
    _i10.GooglePlayPurchaseDetails? purchaseDetails,
    _i10.GooglePlayProductDetails? productDetails,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #purchaseGooglePlay,
          [
            purchaseDetails,
            productDetails,
          ],
        ),
        returnValue: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #purchaseGooglePlay,
            [
              purchaseDetails,
              productDetails,
            ],
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #purchaseGooglePlay,
            [
              purchaseDetails,
              productDetails,
            ],
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveActiveProducts>);
  @override
  _i5.Future<_i3.LinkFiveActiveProducts> purchaseGooglePlayOneTimePurchase(
    _i10.GooglePlayPurchaseDetails? purchaseDetails,
    _i3.OneTimePurchaseOfferDetailsWrapper? otpDetails,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #purchaseGooglePlayOneTimePurchase,
          [
            purchaseDetails,
            otpDetails,
          ],
        ),
        returnValue: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #purchaseGooglePlayOneTimePurchase,
            [
              purchaseDetails,
              otpDetails,
            ],
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #purchaseGooglePlayOneTimePurchase,
            [
              purchaseDetails,
              otpDetails,
            ],
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveActiveProducts>);
  @override
  _i5.Future<_i3.LinkFiveActiveProducts> fetchUserPlanListFromLinkFive() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserPlanListFromLinkFive,
          [],
        ),
        returnValue: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #fetchUserPlanListFromLinkFive,
            [],
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #fetchUserPlanListFromLinkFive,
            [],
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveActiveProducts>);
  @override
  _i5.Future<_i3.LinkFiveActiveProducts> restoreIos(
          List<_i3.LinkFiveRestoreAppleItem>? restoreList) =>
      (super.noSuchMethod(
        Invocation.method(
          #restoreIos,
          [restoreList],
        ),
        returnValue: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #restoreIos,
            [restoreList],
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #restoreIos,
            [restoreList],
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveActiveProducts>);
  @override
  _i5.Future<_i3.LinkFiveActiveProducts> restoreGoogle(
          List<_i3.LinkFiveRestoreGoogleItem>? restoreList) =>
      (super.noSuchMethod(
        Invocation.method(
          #restoreGoogle,
          [restoreList],
        ),
        returnValue: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #restoreGoogle,
            [restoreList],
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #restoreGoogle,
            [restoreList],
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveActiveProducts>);
  @override
  _i5.Future<_i3.LinkFiveActiveProducts> changeUserId(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #changeUserId,
          [userId],
        ),
        returnValue: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #changeUserId,
            [userId],
          ),
        )),
        returnValueForMissingStub: _i5.Future<_i3.LinkFiveActiveProducts>.value(
            _FakeLinkFiveActiveProducts_2(
          this,
          Invocation.method(
            #changeUserId,
            [userId],
          ),
        )),
      ) as _i5.Future<_i3.LinkFiveActiveProducts>);
}

/// A class which mocks [LinkFiveBillingClientInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockLinkFiveBillingClientInterface extends _i1.Mock
    implements _i11.LinkFiveBillingClientInterface {
  @override
  _i5.Future<List<_i2.ProductDetails>?> getPlatformProducts(
          _i3.LinkFiveResponseData? linkFiveResponse) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPlatformProducts,
          [linkFiveResponse],
        ),
        returnValue: _i5.Future<List<_i2.ProductDetails>?>.value(),
        returnValueForMissingStub:
            _i5.Future<List<_i2.ProductDetails>?>.value(),
      ) as _i5.Future<List<_i2.ProductDetails>?>);
}
