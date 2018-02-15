import 'package:taxlogic/taxlogic.dart';
import 'package:test/test.dart';


num fix(num input){

  return num.parse(input.toStringAsFixed(2));

}


void main() {

  incomeTaxEngland();
  incomeTaxScotland();
  nationalInsuranceEarnings();
  nationalInsuranceTrade();
}

void incomeTaxEngland(){
  group('Income tax England', ()
  {
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
      expect(fix(taxPosition.tax), 1800);
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
  });

}

void incomeTaxScotland() {
  group('Income tax Scotland', () {
    IncomeTaxPosition taxPosition;

    setUp(() {
      // put time consuming stuff that only needs to be done once here
    });


    test('20,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 20000, true);
      expect(taxPosition.tax, 1610);
    });

    test('45,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 45000, true);
      expect(fix(taxPosition.tax), 7134);
    });

    test('90,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 90000, true);
      expect(fix(taxPosition.tax), 25584);
    });

    test('200,000 2019 scotland', () {
      taxPosition = new IncomeTaxPosition(2019, 200000, true);
      expect(taxPosition.tax, 78042.50);
    });
  });
}

void nationalInsuranceEarnings() {
  group('National insurance earnings', () {
    NationalInsurancePosition taxPosition;

    setUp(() {
      // put time consuming stuff that only needs to be done once here
    });

    test('5,000 2018 employee', () {
      taxPosition = new NationalInsurancePosition(2018, 5000, 0);
      expect(taxPosition.nicClass1p, 0);
    });

    test('5,000 2018 employer', () {
      taxPosition = new NationalInsurancePosition(2018, 5000, 0);

      expect(taxPosition.nicClass1s, 0);
    });

    test('20,000 2018 employee', () {
      taxPosition = new NationalInsurancePosition(2018, 20000, 0);
      expect(taxPosition.nicClass1p, 1420.8);

    });

    test('20,000 2018 employer', () {
      taxPosition = new NationalInsurancePosition(2018, 20000, 0);

      expect(taxPosition.nicClass1s, 1633.92);
    });

    test('45,000 2018 employee', () {
      taxPosition = new NationalInsurancePosition(2018, 45000, 0);
      expect(fix(taxPosition.nicClass1p), 4420.8);

    });

    test('45,000 2018 employer', () {
      taxPosition = new NationalInsurancePosition(2018, 45000, 0);

      expect(taxPosition.nicClass1s, 5083.92);
    });

    test('90,000 2018 employee', () {
      taxPosition = new NationalInsurancePosition(2018, 90000, 0);
      expect(fix(taxPosition.nicClass1p), 5320.8);

    });

    test('90,000 2018 employer', () {
      taxPosition = new NationalInsurancePosition(2018, 90000, 0);

      expect(taxPosition.nicClass1s, 11293.92);
    });


  });
}

void nationalInsuranceTrade() {
  group('National insurance trade', () {
    NationalInsurancePosition taxPosition;

    setUp(() {
      // put time consuming stuff that only needs to be done once here
    });

    test('5,000 2018', () {
      taxPosition = new NationalInsurancePosition(2018, 0, 5000);
      expect(taxPosition.nicClass4, 0);
    });

    test('20,000 2018', () {
      taxPosition = new NationalInsurancePosition(2018, 0, 20000);
      expect(taxPosition.nicClass4, 1065.24);
    });

    test('45,000 2018', () {
      taxPosition = new NationalInsurancePosition(2018, 0, 45000);
      expect(fix(taxPosition.nicClass4), 3315.24);
    });

    test('90,000 2018', () {
      taxPosition = new NationalInsurancePosition(2018, 0, 90000);
      expect(fix(taxPosition.nicClass4), 4215.24);
    });


  });
}




