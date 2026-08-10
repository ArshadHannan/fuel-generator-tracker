import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app1/pages/generator/remaining_fuel.dart';

void main() {
  group('calculateRemaining', () {
    test('subtracts fuel used by runtime hours from capacity', () {
      final remaining = calculateRemaining(
        capacity: 245,
        usageRate: 5,
        totalHours: 2,
        totalAdded: 0,
      );

      expect(remaining, 235);
    });

    test('adds refuelled liters back on top', () {
      final remaining = calculateRemaining(
        capacity: 245,
        usageRate: 5,
        totalHours: 2,
        totalAdded: 5,
      );

      expect(remaining, 240);
    });

    test('clamps at tank capacity when overfilled', () {
      final remaining = calculateRemaining(
        capacity: 245,
        usageRate: 5,
        totalHours: 2,
        totalAdded: 1000,
      );

      expect(remaining, 245);
    });

    test('clamps at zero when more fuel used than available', () {
      final remaining = calculateRemaining(
        capacity: 100,
        usageRate: 10,
        totalHours: 20,
        totalAdded: 0,
      );

      expect(remaining, 0);
    });

    test('stays at capacity when usage rate is zero', () {
      final remaining = calculateRemaining(
        capacity: 50,
        usageRate: 0,
        totalHours: 100,
        totalAdded: 0,
      );

      expect(remaining, 50);
    });
  });
}
