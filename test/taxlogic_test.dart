import 'package:taxlogic/taxlogic.dart';
import 'package:test/test.dart';


num fix(num input){

  return num.parse(input.toStringAsFixed(2));

}

void main() {

  dates();
  periods();
  incomeTaxEngland2017();
  incomeTaxEngland2018();
  incomeTaxEnglandDividend2018();
  incomeTaxEnglandSavings2018();
  incomeTaxScotland2019();
  nationalInsuranceEarnings();
  nationalInsuranceTrade();
  capitalGains();
}

void dates(){

  group('Dates ', (){

    test('Compare dates 11/3/18 before 12/3/18', () {

      Date first = new Date(11,3,18);
      Date second = new Date(12,3,18);


      expect(first < second, true);
    });

    test('Compare dates 15/3/18 after 12/3/18', () {

      Date first = new Date(15,3,18);
      Date second = new Date(12,3,18);


      expect(first > second, true);
    });

    test('Difference between dates 15/3/18 after 12/3/18', () {

      Date first = new Date(15,3,18);
      Date second = new Date(12,3,18);


      expect(first - second, 3);
    });

    test('Add days to date15/3/18', () {

      Date first = new Date(15,3,18);

      Date result = new Date(18,3,18);

      expect(result - first, 3);
    });

    test('Tax year to 2018 ', () {

      TaxYear taxYear = new TaxYear(2018);

      expect(taxYear.days, 365);
      expect(taxYear.start.day, 6);
      expect(taxYear.start.month, 4);
      expect(taxYear.start.year, 2017);
      expect(taxYear.end.day, 5);
      expect(taxYear.end.month, 4);
      expect(taxYear.end.year, 2018);
    });

    test('Tax year inlcuded dates ', () {

      TaxYear taxYear = new TaxYear(2018);

      expect(taxYear.includes(new Date(5,4,18)), true);
      expect(taxYear.includes(new Date(6,4,17)), true);
      expect(taxYear.includes(new Date(5,4,17)), false);
      expect(taxYear.includes(new Date(1,1,18)), true);
      expect(taxYear.includes(new Date(1,1,19)), false);

    });

  });


}

void periods(){

  group('Periods ', (){

    test('period 11/12/18 to 12/12/18', () {

      Date start = new Date(11,12,18);
      Date end = new Date(12,12,18);

      Period period = new Period (start,end);

      expect(period.duration, 1);
    });

    test('period 13/06/12 to 25/02/13', () {

      Date start = new Date(13,6,12);
      Date end = new Date(25,2,13);

      Period period = new Period (start,end);

      expect(period.duration, 257);
    });

    test('period 17/02/16 to 23/03/18', () {

      Date start = new Date(17,2,16);
      Date end = new Date(23,3,18);

      Period period = new Period (start,end);

      expect(period.duration, 765);
    });

    test('period 01/01/17 to 31/10/18', () {

      Date start = new Date(1,1,17);
      Date end = new Date(31,10,18);

      Period period = new Period (start,end);

      expect(period.duration, 668);
    });

    test('period 01/01/1956 to 01/01/12', () {

      Date start = new Date(1,1,56);
      Date end = new Date(1,1,12);

      Period period = new Period (start,end);

      expect(period.duration, 20454);
    });



  });


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

void incomeTaxEnglandDividend2018(){

  Person person;
  TaxPosition taxPosition;
  IncomeTaxPosition incomeTaxPosition;

  group('Income tax dividned 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      person.setTaxPositions();
      taxPosition = person.getYear(2018);
      incomeTaxPosition = taxPosition.incomeTax;
    });


    test('1,000 2018 no other income', () {
      taxPosition.dividend = 1000;
      taxPosition.earnings = 0;
      incomeTaxPosition.calculate();
      expect(fix(incomeTaxPosition.tax), 0);
    });

    test('1,000 2018 20000 income', () {
      taxPosition.dividend = 1000;
      taxPosition.earnings = 20000;
      incomeTaxPosition.calculate();
      expect(fix(incomeTaxPosition.tax), 1700);
    });

    test('6,000 2018 20000 income', () {
      taxPosition.dividend = 6000;
      taxPosition.earnings = 20000;
      incomeTaxPosition.calculate();
      expect(fix(incomeTaxPosition.tax), 1775);
    });

    test('40,000 2018 no other income', () {
      taxPosition.dividend = 40000;
      taxPosition.earnings = 0;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 1762.50);
    });

    test('10,000 2018 20000 other', () {
      taxPosition.dividend = 20000;
      taxPosition.earnings = 10000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 1012.5);
    });

    test('60,000 2018 10000 other', () {
      taxPosition.dividend = 60000;
      taxPosition.earnings = 10000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 10262.5);
    });

    test('20,000 2018 30000 other', () {
      taxPosition.dividend = 20000;
      taxPosition.earnings = 30000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 6075);
    });

    test('80,000 2018 30000 other', () {
      taxPosition.dividend = 80000;
      taxPosition.earnings = 30000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 27825);
    });

    test('100,000 2018 30000 other', () {
      taxPosition.dividend = 100000;
      taxPosition.earnings = 30000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 36875);
    });

    test('50,000 2018 150000 other', () {
      taxPosition.dividend = 50000;
      taxPosition.earnings = 150000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 70445);
    });

    test('60,000 2018 no other income', () {
      taxPosition.dividend = 60000;
      taxPosition.earnings = 0;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 7012.50);
    });

    test('100,000 2018 no other income', () {
      taxPosition.dividend = 100000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 20012.50);
    });

    test('200,000 2018 no other income', () {
      taxPosition.dividend = 200000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 59050);
    });


  });

}

void incomeTaxEnglandSavings2018(){

  Person person;
  TaxPosition taxPosition;
  IncomeTaxPosition incomeTaxPosition;

  group('Income tax savings 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      person.setTaxPositions();
      taxPosition = person.getYear(2018);
      incomeTaxPosition = taxPosition.incomeTax;
    });


    test('4,000 2018 savings', () {
      taxPosition.dividend = 0;
      taxPosition.earnings = 0;
      taxPosition.savings = 4000;
      incomeTaxPosition.calculate();
      expect(fix(incomeTaxPosition.tax), 0);
    });

    test('40,000 2018 savings', () {
      taxPosition.earnings = 6000;
      taxPosition.savings = 4000;
      taxPosition.dividend = 5000;

      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 0);
    });

    test('10,000 2018 savings', () {
      taxPosition.earnings = 10000;
      taxPosition.savings = 5000;
      taxPosition.dividend = 20000;

      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 1625);
    });

    test('60,000 2018 savings', () {
      taxPosition.earnings = 10000;
      taxPosition.savings = 2000;
      taxPosition.dividend = 60000;

      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 10750);
    });

    test('20,000 2018 savings', () {
      taxPosition.earnings = 10000;
      taxPosition.savings = 6000;
      taxPosition.dividend = 4000;

      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 200);
    });

    test('80,000 2018 savings', () {
      taxPosition.dividend = 80000;
      taxPosition.earnings = 30000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 27825);
    });

    test('100,000 2018 savings', () {
      taxPosition.dividend = 100000;
      taxPosition.earnings = 30000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 36875);
    });

    test('50,000 2018 savings', () {
      taxPosition.dividend = 50000;
      taxPosition.earnings = 150000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 70445);
    });

    test('60,000 2018 savings', () {
      taxPosition.dividend = 60000;
      taxPosition.earnings = 0;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 7012.50);
    });

    test('100,000 2018 savings', () {
      taxPosition.dividend = 100000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 20012.50);
    });

    test('200,000 2018 savings', () {
      taxPosition.dividend = 200000;
      taxPosition.incomeTax.calculate();
      expect(fix(taxPosition.incomeTax.tax), 59050);
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

void capitalGains() {

  group('Capital gains 2018', () {

    Person person;

    setUp(()  {
     person = new Person();
     person.taxPosition2018 = new TaxPosition(person, 2018);
    });


    test('gain proceeds 10000 cost 5000', () {

      ChargeableAsset asset = new ChargeableAsset();
      asset.cost = 5000;
      asset.proceeds = 10000;

      expect(asset.calculateGain(), 5000);

    });

    test('One asset with gain of 5000', () {

      ChargeableAsset asset = new ChargeableAsset();
      asset.cost = 5000;
      asset.proceeds = 10000;
      asset.saleDate = new Date(5,4,18);
      person.assets.add(asset);

      person.taxPosition2018.capitalGainsTaxPosition.calculate();

      expect(person.taxPosition2018.capitalGainsTaxPosition.totalGains, 5000);
    });

    test('One asset with gain of 13000', () {


      // gain 0f 13000
      ChargeableAsset asset01 = new ChargeableAsset();
      asset01.cost = 2000;
      asset01.proceeds = 15000;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset();
      asset02.cost = 5000;
      asset02.proceeds = 1000;
      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);


      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset();
      asset03.cost = 5000;
      asset03.proceeds = 10000;
      asset03.saleDate = new Date(6,4,18);
      person.assets.add(asset03);

     person.taxPosition2018.capitalGainsTaxPosition.calculate();

      expect(person.taxPosition2018.capitalGainsTaxPosition.totalGains, 13000);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLosses, 4000);

    });

    test('Mixed gains and losses 1', () {

    person.taxPosition2018.capitalGainsTaxPosition.capitalLossesBroughtForward = 500;

      // gain 0f 13000
      ChargeableAsset asset01 = new ChargeableAsset();
      asset01.cost = 2000;
      asset01.proceeds = 15000;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset();
      asset02.cost = 5000;
      asset02.proceeds = 1000;
      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);


      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset();
      asset03.cost = 5000;
      asset03.proceeds = 10000;
      asset03.saleDate = new Date(6,4,18);
      person.assets.add(asset03);

      person.taxPosition2018.capitalGainsTaxPosition.calculate();

      expect(person.taxPosition2018.capitalGainsTaxPosition.totalGains, 13000);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLosses, 4000);
    expect(person.taxPosition2018.capitalGainsTaxPosition.netGains, 11300);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLossesCarriedForward, 2800);
    });

    test('Mixed gains and losses 2', () {

      person.taxPosition2018.capitalGainsTaxPosition.capitalLossesBroughtForward = 500;

      // gain 0f 15500
      ChargeableAsset asset01 = new ChargeableAsset();
      asset01.cost = 2000;
      asset01.proceeds = 17500;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset();
      asset02.cost = 5000;
      asset02.proceeds = 1000;
      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);


      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset();
      asset03.cost = 5000;
      asset03.proceeds = 10000;
      asset03.saleDate = new Date(6,4,18);
      person.assets.add(asset03);

      person.taxPosition2018.capitalGainsTaxPosition.calculate();

      expect(person.taxPosition2018.capitalGainsTaxPosition.totalGains, 15500);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLosses, 4000);
      expect(person.taxPosition2018.capitalGainsTaxPosition.netGains, 11300);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLossesCarriedForward, 300);
      expect(person.taxPosition2018.capitalGainsTaxPosition.taxableGains, 0);
    });

    test('Residential Property', () {

      // gain 0f 15500
      ChargeableAsset asset01 = new ChargeableAsset();
      asset01.cost = 2000;
      asset01.proceeds = 17500;
      asset01.saleDate = new Date(5,4,18);
      asset01.residentialProperty = true;
      person.assets.add(asset01);


      person.taxPosition2018.capitalGainsTaxPosition.calculate();

      expect(person.taxPosition2018.capitalGainsTaxPosition.totalGains, 15500);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLosses, 0);
      expect(person.taxPosition2018.capitalGainsTaxPosition.netGains, 15500);
      expect(person.taxPosition2018.capitalGainsTaxPosition.taxableGains, 4200);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLossesCarriedForward, 0);
    });

    test('Residential Property', () {

      // gain 0f 15500
      ChargeableAsset asset01 = new ChargeableAsset();
      asset01.cost = 2000;
      asset01.proceeds = 17500;
      asset01.saleDate = new Date(5,4,18);
      asset01.residentialProperty = true;
      person.assets.add(asset01);
      person.taxPosition2018.earnings = 20000;


      person.taxPosition2018.capitalGainsTaxPosition.calculate();

      expect(person.taxPosition2018.capitalGainsTaxPosition.totalGains, 15500);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLosses, 0);
      expect(person.taxPosition2018.capitalGainsTaxPosition.netGains, 15500);
      expect(person.taxPosition2018.capitalGainsTaxPosition.taxableGains, 4200);
      expect(person.taxPosition2018.capitalGainsTaxPosition.capitalLossesCarriedForward, 0);
      expect(person.taxPosition2018.capitalGainsTaxPosition.basicRateAmount, 25000);
    });


  });
}




