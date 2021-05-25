import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkfive_purchases/linkfive_purchases.dart';

void main() {
  const MethodChannel channel = MethodChannel('linkfive_purchases');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LinkfivePurchases.platformVersion, '42');
  });
}
