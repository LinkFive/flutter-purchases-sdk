import 'package:linkfive_purchases/models/period.dart';
import 'package:test/test.dart';

void main() {
  group("Parser Test", () {
    test('T1', () {
      const t = "P1D";

      final p = Period.fromGooglePlay(t);
      assert(p.amount == 1);
      assert(p.periodUnit == PeriodUnit.DAYS);
    });
    test('T2', () {
      const t = "P1W";

      final p = Period.fromGooglePlay(t);
      assert(p.amount == 1);
      assert(p.periodUnit == PeriodUnit.WEEKS);
    });
    test('T3', () {
      const t = "P1M";

      final p = Period.fromGooglePlay(t);
      assert(p.amount == 1);
      assert(p.periodUnit == PeriodUnit.MONTH);
    });
    test('T4', () {
      const t = "P1Y";

      final p = Period.fromGooglePlay(t);
      assert(p.amount == 1);
      assert(p.periodUnit == PeriodUnit.YEARS);
    });
    test('T5', () {
      const t = "P3D";

      final p = Period.fromGooglePlay(t);
      assert(p.amount == 3);
      assert(p.periodUnit == PeriodUnit.DAYS);
    });
    test('T6', () {
      const t = "P30D";

      final p = Period.fromGooglePlay(t);
      assert(p.amount == 30);
      assert(p.periodUnit == PeriodUnit.DAYS);
    });
    test('T7', () {
      const t = "P30DD";

      final p = Period.fromGooglePlay(t);
      assert(p.amount == 30);
      assert(p.periodUnit == PeriodUnit.DAYS);
    });
    test('T8', () {
      const t = "P3X";

      expect(() => Period.fromGooglePlay(t), throwsA(isA<UnsupportedError>()));
    });
    test('T9', () {
      const t = "";

      expect(() => Period.fromGooglePlay(t), throwsA(isA<ArgumentError>()));
    });
  });
}
