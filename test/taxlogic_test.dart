import 'package:taxlogic/taxlogic.dart';
import 'package:test/test.dart';


num fix(num input){

  return num.parse(input.toStringAsFixed(2));

}


void main() {



  incomeTaxEngland2017();
  incomeTaxEngland2018();
  incomeTaxScotland2019();
  nationalInsuranceEarnings();
  nationalInsuranceTrade();
}

void incomeTaxEngland2017(){

  Person person;
  TaxPosition taxPosition;
  IncomeTaxPosition incomeTaxPosition;

  group('Income tax England 2017', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      person.setTaxPositions();
      taxPosition = person.getYear(2017);
      incomeTaxPosition = taxPosition.incomeTax;
    });


    test('20,000 2017 england', () {
      taxPosition.earnings = 20000;
      incomeTaxPosition.calculate();
      expect(fix(incomeTaxPosition.tax), 1800);
    });

    test('45,000 2017 england', () {
      taxPosition.earnings = 45000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 7200);
    });

    test('90,000 2017 england', () {
      taxPosition.earnings = 90000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 25200);
    });

    test('200,000 2017 england', () {
      taxPosition.earnings = 200000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 76100);
    });


  });

}

void incomeTaxEngland2018(){

  Person person;
  TaxPosition taxPosition;
  IncomeTaxPosition incomeTaxPosition;

  group('Income tax England 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      person.setTaxPositions();
      taxPosition = person.getYear(2018);
      incomeTaxPosition = taxPosition.incomeTax;
    });


    test('20,000 2018 england', () {
      taxPosition.earnings = 20000;
      incomeTaxPosition.calculate();
      expect(fix(incomeTaxPosition.tax), 1700);
    });

    test('45,000 2018 england', () {
      taxPosition.earnings = 45000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 6700);
    });

    test('90,000 2018 england', () {
      taxPosition.earnings = 90000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 24700);
    });

    test('200,000 2018 england', () {
      taxPosition.earnings = 200000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 75800);
    });


  });

}

void incomeTaxScotland2019(){

  Person person;
  TaxPosition taxPosition;
  IncomeTaxPosition incomeTaxPosition;

  group('Income tax Scotland 2019', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = true;
      person.setTaxPositions();
      taxPosition = person.getYear(2019);
      incomeTaxPosition = taxPosition.incomeTax;
    });


    test('20,000 2019 scotland', () {
      taxPosition.earnings = 20000;
      incomeTaxPosition.calculate();
      expect(fix(incomeTaxPosition.tax), 1610);
    });

    test('45,000 2019 scotland', () {
      taxPosition.earnings = 45000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 7134);
    });

    test('90,000 2019 scotland', () {
      taxPosition.earnings = 90000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 25584);
    });

    test('200,000 2019 scotland', () {
      taxPosition.earnings = 200000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 78042.50);
    });


  });

}

void nationalInsuranceEarnings() {

  Person person;
  TaxPosition taxPosition;
  NationalInsurancePosition nicPosition;

  group('National insurance earnings', () {

    setUp(() {
      person = new Person();
      person.scotland = false;
      person.setTaxPositions();
      taxPosition = person.getYear(2018);
      nicPosition = taxPosition.nicPosition;
    });

    test('5,000 2018 employee', () {
      taxPosition.earnings = 5000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1p), 0);
    });

    test('5,000 2018 employer', () {
      taxPosition.earnings = 5000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1s), 0);
    });

    test('20,000 2018 employee', () {
      taxPosition.earnings = 20000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1p), 1420.8);

    });

    test('20,000 2018 employer', () {
      taxPosition.earnings = 20000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1s), 1633.92);
    });

    test('45,000 2018 employee', () {
      taxPosition.earnings = 45000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1p), 4420.8);

    });

    test('45,000 2018 employer', () {
      taxPosition.earnings = 45000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1s), 5083.92);
    });

    test('90,000 2018 employee', () {
      taxPosition.earnings = 90000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1p), 5320.8);

    });

    test('90,000 2018 employer', () {
      taxPosition.earnings = 90000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass1s), 11293.92);
    });


  });
}

void nationalInsuranceTrade() {

  Person person;
  TaxPosition taxPosition;
  NationalInsurancePosition nicPosition;

  group('National insurance trade', () {

    setUp(() {
      person = new Person();
      person.scotland = false;
      person.setTaxPositions();
      taxPosition = person.getYear(2018);
      nicPosition = taxPosition.nicPosition;
    });

    test('5,000 2018 trade', () {
      taxPosition.trade = 5000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass4), 0);
    });

    test('20,000 2018 trade', () {
      taxPosition.trade = 20000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass4), 1065.24);

    });


    test('45,000 2018 trade', () {
      taxPosition.trade = 45000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass4), 3315.24);

    });

    test('90,000 2018 trade', () {
      taxPosition.trade = 90000;
      nicPosition.calculate();
      expect(fix(nicPosition.nicClass4), 4215.24);

    });


  });
}




