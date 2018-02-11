import 'package:taxlogic/taxlogic.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    IncomeTaxPosition taxPosition;

    setUp(() {
        // put time consuming stuff that only needs to be done once here
    });

    test('First Test', () {
      taxPosition = new IncomeTaxPosition(2017, 0, false);
      expect(taxPosition.tax, 0);
    });

    test('20,000 2017 england', () {
      taxPosition = new IncomeTaxPosition(2017, 20000, false);
      expect(taxPosition.tax, 1800);
    });

    test('45,000 2017 england', () {
      taxPosition = new IncomeTaxPosition(2017, 45000, false);
      expect(taxPosition.tax, 7200);
    });

    test('90,000 2017 england', () {
      taxPosition = new IncomeTaxPosition(2017, 90000, false);
      expect(taxPosition.tax, 25200);
    });

    test('200,000 2017 england', () {
      taxPosition = new IncomeTaxPosition(2017, 200000, false);
      expect(taxPosition.tax, 76100);
    });

    test('20,000 2018 england', () {
      taxPosition = new IncomeTaxPosition(2018, 20000, false);
      expect(taxPosition.tax, 1700);
    });

    test('45,000 2018 england', () {
      taxPosition = new IncomeTaxPosition(2018, 45000, false);
      expect(taxPosition.tax, 6700);
    });

    test('90,000 2018 england', () {
      taxPosition = new IncomeTaxPosition(2018, 90000, false);
      expect(taxPosition.tax, 24700);
    });

    test('200,000 2018 england', () {
      taxPosition = new IncomeTaxPosition(2018, 200000, false);
      expect(taxPosition.tax, 75800);
    });

    test('20,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 20000, true);
      expect(taxPosition.tax, 1610);
    });

    test('45,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 45000, true);
      expect(taxPosition.tax, 7134);
    });

    test('90,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 90000, true);
      expect(taxPosition.tax, 25584);
    });

    test('200,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 200000, true);
      expect(taxPosition.tax, 78042.50);
    });
  });
}
