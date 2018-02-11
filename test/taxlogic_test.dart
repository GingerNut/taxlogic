import 'package:taxlogic/taxlogic.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    IncomeTaxPosition taxPosition;

    setUp(() {
        // put time consuming stuff that only needs to be done once here
    });

    test('First Test', () {
      taxPosition = new IncomeTaxPosition(2018, 0, false);
      expect(taxPosition.tax, 0);
    });
  });
}
