import 'package:taxlogic/taxlogic.dart';
import 'package:test/test.dart';

void main() {
  game();
  dates();
  periods();
  rateChange();
  taxdata();
  incomeTaxEngland2017();
  incomeTaxEngland2018();
  incomeTaxEnglandDividend2018();
  incomeTaxEnglandSavings2018();
  incomeTaxScotland2019();
  nationalInsuranceEarnings();
  nationalInsuranceTrade();
  capitalGains();
  incomeAndExpenditure();
  corporationTax();
}

void game(){

  group('Game elements ', (){

    test('Basic game ', (){
      Game game = new Game();

      Move move = new CreateEntity(new Date(6,4,17), 'Harry',Entity.INDIVIDUAL );

      game.makeMove(move);

      String personId = 'Harry';
      String employmentId = 'Job';

      game.makeMove(new StartEmployment(personId, employmentId, new Date(6,10,17), 80000));

      Person person = game.position.getEntityByName(personId);

      expect(person.taxYear(2018).tax, 5678.08);
      expect(person.activities[0].annualIncome.rateAt(new Date(6,4,17)), 0);
      expect(person.activities[0].annualIncome.rateAt(new Date(5,10,17)), 0);
      expect(person.activities[0].annualIncome.rateAt(new Date(6,10,17)), 80000);

      expect(person.taxYear(2019).earningsIncome , 80000);

      game.makeMove(new EndEmployment(employmentId, new Date(6,10,18), 0));

      expect(person.taxYear(2020).tax , 80000);

    });

    test('Landlord start ', () {

    });


  });

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

    test('equality ', () {

      Date first = new Date(15,3,18);
      Date second = new Date(15,3,19);

      expect(first == second, false);

      first = new Date(15,3,18);
      second = new Date(15,4,18);

      expect(first == second, false);

      first = new Date(15,3,18);
      second = new Date(16,3,18);

      expect(first == second, false);

      first = new Date(16,3,18);
      second = new Date(16,3,18);

      expect(first == second, true);

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

    test('leap year ', () {
      expect(Date.isleap(2019), false);
      expect(Date.isleap(2017), false);
      expect(Date.isleap(2018), false);
      expect(Date.isleap(2016), true);
      expect(Date.isleap(2004), true);
      expect(Date.isleap(2020), true);
    });

    test('tax year ', () {
      expect(new Date(5,4,19).taxYear, 2019);
      expect(new Date(6,4,19).taxYear, 2020);
      expect(new Date(30,6,17).taxYear, 2018);
      expect(new Date(1,1,17).taxYear, 2017);
      expect(new Date(31,12,20).taxYear, 2021);
    });

    test('financial year ', () {
      expect(new Date(31,3,19).financialYear, 2019);
      expect(new Date(1,4,19).financialYear, 2020);
      expect(new Date(30,6,17).financialYear, 2018);
      expect(new Date(1,1,17).financialYear, 2017);
      expect(new Date(31,12,20).financialYear, 2021);
    });

    test('period ends ', () {

      PeriodEnd periodEnd = new PeriodEnd(30, 6);
      Date test = new Date(5,4,19);

      expect(periodEnd.next(test).year, 2019);
      expect(periodEnd.next(test).month, 6);
      expect(periodEnd.next(test).day, 30);

      test = new Date(30,6,2020);

      expect(periodEnd.next(test).year, 2020);
      expect(periodEnd.next(test).month, 6);
      expect(periodEnd.next(test).day, 30);

      test = new Date(1,7,2020);

      expect(periodEnd.next(test).year, 2021);
      expect(periodEnd.next(test).month, 6);
      expect(periodEnd.next(test).day, 30);

      periodEnd = new PeriodEnd(5, 4);
      test = new Date(6,4,2019);

      expect(periodEnd.next(test).year, 2020);
      expect(periodEnd.next(test).month, 4);
      expect(periodEnd.next(test).day, 5);

      test = new Date(5,4,2019);

      expect(periodEnd.next(test).year, 2019);
      expect(periodEnd.next(test).month, 4);
      expect(periodEnd.next(test).day, 5);

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

    test('period 02/01/18 to 01/01/19 i nmonths', () {

      Date start = new Date(2,1,18);
      Date end = new Date(1,1,19);

      Period period = new Period (start,end);

      expect(period.completeMonths(), 11);
    });

    test('period 02/01/19 to 01/01/18 i nmonths', () {

      Date start = new Date(2,1,19);
      Date end = new Date(1,1,18);

      Period period = new Period (start,end);

      expect(period.completeMonths(), 12);
    });

    test('period 25/06/17 to 23/12/17 ni nmonths', () {

      Date start = new Date(25,06,17);
      Date end = new Date(23,12,17);

      Period period = new Period (start,end);

      expect(period.completeMonths(), 5);
    });

    test('period 25/06/17 to 23/12/18 ni nmonths', () {

      Date start = new Date(25,06,17);
      Date end = new Date(23,12,18);

      Period period = new Period (start,end);

      expect(period.completeMonths(), 17);
    });

    test('overlap ', () {

      Date startOne = new Date(1,1,17);
      Date endOne = new Date(30,6,17);

      Date startTwo = new Date(1,1,18);
      Date endTwo = new Date(30,6,18);

      Period one = new Period (startOne, endOne);
      Period two = new Period (startTwo, endTwo);

      expect(Period.overlap(one, two), 0);
    });

    test('overlap ', () {

      Date startOne = new Date(1,1,17);
      Date endOne = new Date(30,6,17);

      Date startTwo = new Date(1,1,17);
      Date endTwo = new Date(30,6,17);

      Period one = new Period (startOne, endOne);
      Period two = new Period (startTwo, endTwo);

      expect(Period.overlap(one, two), one.days);
    });

    test('overlap ', () {

      Date startOne = new Date(1,1,17);
      Date endOne = new Date(30,6,17);

      Date startTwo = new Date(1,6,17);
      Date endTwo = new Date(30,6,18);

      Period one = new Period (startOne, endOne);
      Period two = new Period (startTwo, endTwo);

      expect(Period.overlap(one, two), 30);
    });

    test('months to date ', () {

      Date end = new Date(31,12,18);
      int months = 12;

      Period period = Period.monthsTo(end, months);

      expect(period.start.day, 1);
      expect(period.start.month, 1);
      expect(period.start.year, 2018);
    });

    test('months to date ', () {

      Date end = new Date(31,12,18);
      int months = 18;

      Period period = Period.monthsTo(end, months);

      expect(period.start.day, 1);
      expect(period.start.month, 7);
      expect(period.start.year, 2017);
    });

    test('months to date ', () {

      Date end = new Date(15,1,18);
      int months = 2;

      Period period = Period.monthsTo(end, months);

      expect(period.start.day, 16);
      expect(period.start.month, 11);
      expect(period.start.year, 2017);
    });

    test('sort periods ', () {

      Period one = new Period(new Date(1,1,15), new Date(1,3,17));
      Period two = new Period(new Date(1,1,14), new Date(1,3,14));
      Period three = new Period(new Date(1,1,18), new Date(1,3,18));

      List<Period> periods = new List();
      periods.add(one);
      periods.add(two);
      periods.add(three);

      List<Period> sorted = Period.sortPeriods(periods);

      expect(sorted[0].start.year, 2014);
      expect(sorted[1].start.year, 2015);
      expect(sorted[2].start.year, 2018);
    });

    test('consolidate periods ', () {

      Period one = new Period(new Date(1,1,15), new Date(1,3,17));
      Period two = new Period(new Date(1,4,18), new Date(1,5,18));
      Period three = new Period(new Date(1,1,18), new Date(30,4,18));
      Period four = new Period(new Date(1,1,14), new Date(1,3,15));

      List<Period> periods = new List();
      periods.add(one);
      periods.add(two);
      periods.add(three);
      periods.add(four);

     List<Period> consolidated = Period.consolidatePeriods(periods);

      expect(consolidated[0].start.year, 2014);
      expect(consolidated[0].start.month, 1);
      expect(consolidated[0].start.day, 1);
      expect(consolidated[0].end.year, 2017);
      expect(consolidated[0].end.month, 3);
      expect(consolidated[0].end.day, 1);
      expect(consolidated[1].start.year, 2018);
      expect(consolidated[1].start.month, 1);
      expect(consolidated[1].start.day, 1);
      expect(consolidated[1].end.year, 2018);
      expect(consolidated[1].end.month, 5);
      expect(consolidated[1].end.day, 1);

    });

    test('period collection ', () {

      Company company = new Company();
      
      Period one = new Period(new Date(1,7,2018), new Date(31,7,2018));
      Period two = new Period(new Date(1,8,2018), new Date(31,8,2018));
      Period test =new Period(new Date(15,7,2018), new Date(15,8,2018));

      CompanyAccountingPeriod period1 = new CompanyAccountingPeriod(company, one);
      CompanyAccountingPeriod period2 = new CompanyAccountingPeriod(company, two);

      company.taxPeriods.add(period1);
      company.taxPeriods.add(period2);

      PeriodCollection collection = new PeriodCollection(test, company);
      PeriodFraction fraction1 = collection.periods[0];
      PeriodFraction fraction2 = collection.periods[1];

      expect(collection.periods.length, 2);
      expect(fraction1.days, 17);
      expect(fraction1.taxPosition.period.end.day, 31);
      expect(fraction1.taxPosition.period.end.month , 7);
      expect(fraction1.taxPosition.period.end.year, 2018);

      expect(fraction2.days, 15);
      expect(fraction2.taxPosition.period.end.day, 31);
      expect(fraction2.taxPosition.period.end.month , 8);
      expect(fraction2.taxPosition.period.end.year, 2018);


    });


  });


}

void rateChange(){

  RateHistory history = new RateHistory([
    new RateChange(new Date(6,4,08),50000),
    new RateChange(new Date(6,4,10),100000),
    new RateChange(new Date(6,4,12),25000),
    new RateChange(new Date(1,1,13),250000),
    new RateChange(new Date(6,4,14),500000),
    new RateChange(new Date(1,1,16),200000),
  ]);

  group('Rate histories ', (){

    test('Last rate change', () {

     expect(history.lastChange(new Date(1,1,15)).day, 6);
     expect(history.lastChange(new Date(1,1,15)).month, 4);
     expect(history.lastChange(new Date(1,1,15)).year, 2014);

    });

    test('Next rate change', () {

      expect(history.nextChange(new Date(1,1,15)).day, 1);
      expect(history.nextChange(new Date(1,1,15)).month, 1);
      expect(history.nextChange(new Date(1,1,15)).year, 2016);

    });

    test('Next rate change', () {

      expect(history.nextChange(new Date(6,4,14)).day, 1);
      expect(history.nextChange(new Date(6,4,14)).month, 1);
      expect(history.nextChange(new Date(6,4,14)).year, 2016);

    });

    test('Next rate change', () {

      expect(history.nextChange(new Date(1,1,17)), null);


    });


    test('Rate at date ', () {

      expect(history.rateAt(new Date(1,1,14)), 250000);


    });

    test('Rate periods ', () {

      Date start = new Date(1,1,14);
      Date end = new Date(31,12,17);

      Period period = new Period(start, end);

      List<RatePeriod> ratePeriods = history.getRatePeriods(period);
     
      expect(ratePeriods[0].rate, 250000);
      expect(ratePeriods[0].period.start.day, 1);
      expect(ratePeriods[0].period.start.month, 1);
      expect(ratePeriods[0].period.start.year, 2014);
      expect(ratePeriods[0].period.end.day, 5);
      expect(ratePeriods[0].period.end.month, 4);
      expect(ratePeriods[0].period.end.year, 2014);

      expect(ratePeriods[1].rate, 500000);
      expect(ratePeriods[1].period.start.day, 6);
      expect(ratePeriods[1].period.start.month, 4);
      expect(ratePeriods[1].period.start.year, 2014);
      expect(ratePeriods[1].period.end.day, 31);
      expect(ratePeriods[1].period.end.month, 12);
      expect(ratePeriods[1].period.end.year, 2015);

      expect(ratePeriods[2].rate, 200000);
      expect(ratePeriods[2].period.start.day, 1);
      expect(ratePeriods[2].period.start.month, 1);
      expect(ratePeriods[2].period.start.year, 2016);
      expect(ratePeriods[2].period.end.day, 31);
      expect(ratePeriods[2].period.end.month, 12);
      expect(ratePeriods[2].period.end.year, 2017);

    });

    test('Overall rate ', () {

      Date start = new Date(1,7,15);
      Date end = new Date(30,6,16);

      Period period = new Period(start, end);

      expect(history.overallAmount(period), 351232.88);


    });

    test('Overall rate ', () {

      Date start = new Date(1,10,15);
      Date end = new Date(30,6,16);

      Period period = new Period(start, end);

      expect(history.overallAmount(period), 225205.48);


    });

    test('Overall interst ', () {

      Date start = new Date(1,1,12);
      Date end = new Date(21,9,17);

      Period period = new Period(start, end);

      expect(TaxData.OverdueInterestTotal(period), 16.91);


    });

    test('Rental income  ', () {
      Person person = new Person();
      ResidentialProperty property = new ResidentialProperty(person);

      Date date1 = new Date(1,1,17);
      num amount1 = 10000;

      Date date2 = new Date(1,1,18);
      num amount2 = 15000;

      property.setRent(amount1, date1);

      Date start = new Date(1,1,17);
      Date end = new Date(31,12,17);

      Period period = new Period(start, end);

      expect(property.rent(period), 10000);

    });

    test('Rental income  ', () {
      Person person = new Person();
      ResidentialProperty property = new ResidentialProperty(person);

      Date date1 = new Date(1,1,17);
      num amount1 = 10000;

      Date date2 = new Date(1,1,18);
      num amount2 = 15000;

      property.setRent(amount1, date1);
      property.setRent(amount2, date2);

      Date start = new Date(1,7,17);
      Date end = new Date(30,6,18);

      Period period = new Period(start, end);

      expect(property.rent(period), 12438.36);

    });

    test('Test default amount  ', () {

      RateHistory history = new RateHistory.empty();
      history.set(5000);

      Date test = new Date(21,9,62);

      expect(history.rateAt(test), 5000);

    });

  });


}

void taxdata(){

  group('Data ', (){

    Person individual;
    Company company;

    setUp(() {
      individual = new Person();
      company = new Company();

    });

    test('Corporation tax main rate', () {

      expect(TaxData.CompanyMainRate(new Date (31,3,16)), 0.20);
      expect(TaxData.CompanyMainRate(new Date (1,4,17)), 0.19);
      expect(TaxData.CompanyMainRate(new Date (1,4,18)), 0.19);
      expect(TaxData.CompanyMainRate(new Date (1,4,19)), 0.19);
      expect(TaxData.CompanyMainRate(new Date (31,3,20)), 0.19);
      expect(TaxData.CompanyMainRate(new Date (1,4,20)), 0.17);
    });

    test('Annual investment allowance', () {

      expect(TaxData.AnnualInvestmentAllowance(new Date (1,1,2016), individual), 200000);
      expect(TaxData.AnnualInvestmentAllowance(new Date (6,4,10), individual), 100000);
      expect(TaxData.AnnualInvestmentAllowance(new Date (6,4,12), individual), 25000);

      expect(TaxData.AnnualInvestmentAllowance(new Date (1,1,2016), company), 200000);
      expect(TaxData.AnnualInvestmentAllowance(new Date (1,4,10), company), 100000);
      expect(TaxData.AnnualInvestmentAllowance(new Date (1,4,12), company), 25000);



    });

    test('Indexation ', () {

      Date purchase = new Date(1,1,83);
      Date sale = new Date(1,1,17);

      expect(TaxData.IndexationFactor(purchase, sale), 2.214);

    });

    test('Indexation ', () {

      Date purchase = new Date(1,12,90);
      Date sale = new Date(1,3,16);

      expect(TaxData.IndexationFactor(purchase, sale), 1.010);

    });

    test('Indexation ', () {

      Date purchase = new Date(1,1,82);
      Date sale = new Date(1,2,18);

      expect(TaxData.IndexationFactor(purchase, sale), 2.501);

    });



  });


}

void incomeTaxEngland2017(){

  Person person;
  PersonalTaxPosition taxPosition;
  Income earnings;

  group('Income tax England 2017', ()
  {



    setUp(() {
      person = new Person();
      person.scotland = false;
      Employment employment = new Employment(person);
      taxPosition = person.taxYear(2017);
      earnings = new Income(employment, taxPosition);
    });


    test('20,000 2017 england', () {
      earnings.income = 20000;
      expect(taxPosition.tax, 1800);
    });

    test('45,000 2017 england', () {
      earnings.income= 45000;

      expect(taxPosition.tax, 7200);
    });

    test('90,000 2017 england', () {
      earnings.income= 90000;

      expect(taxPosition.tax, 25200);
    });

    test('200,000 2017 england', () {
      earnings.income= 200000;
      expect(taxPosition.tax, 76100);
    });


  });

}

void incomeTaxEngland2018(){

  Person person;
  PersonalTaxPosition taxPosition;
  Income earnings;

  group('Income tax England 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      taxPosition = person.taxYear(2018);

      Employment employment = new Employment(person);
      earnings = new Income(employment, taxPosition);

    });


    test('20,000 2018 england', () {
      earnings.income= 20000;

      expect(taxPosition.tax, 1700);
    });

    test('45,000 2018 england', () {
      earnings.income= 45000;
      expect(taxPosition.tax, 6700);
    });

    test('90,000 2018 england', () {
      earnings.income= 90000;

      expect(taxPosition.tax, 24700);
    });

    test('200,000 2018 england', () {
      earnings.income= 200000;
      expect(taxPosition.tax, 75800);
    });


  });

}

void incomeTaxEnglandDividend2018(){

  Person person;
  PersonalTaxPosition taxPosition;
  Income earnings;
  Income dividend;

  group('Income tax dividned 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      
      taxPosition = person.taxYear(2018);

      Employment employment = new Employment(person);
      earnings = new Income(employment, taxPosition);

      ShareHolding investment = new ShareHolding(person);
      dividend = new Income(investment, taxPosition);


    });


    test('1,000 2018 no other income', () {
      dividend.income= 1000;
      earnings.income= 0;
      expect(taxPosition.tax, 0);
    });

    test('1,000 2018 20000 income', () {
      dividend.income= 1000;
      earnings.income= 20000;
      expect(taxPosition.tax, 1700);
    });

    test('6,000 2018 20000 income', () {
      dividend.income= 6000;
      earnings.income= 20000;
      expect(taxPosition.tax, 1775);
    });

    test('40,000 2018 no other income', () {
      dividend.income= 40000;
      earnings.income= 0;
      expect(taxPosition.tax, 1762.50);
    });

    test('10,000 2018 20000 other', () {
      dividend.income= 20000;
      earnings.income= 10000;
      expect(taxPosition.tax, 1012.5);
    });

    test('60,000 2018 10000 other', () {
      dividend.income= 60000;
      earnings.income= 10000;
      expect(taxPosition.tax, 10262.5);
    });

    test('20,000 2018 30000 other', () {
      dividend.income= 20000;
      earnings.income= 30000;
      expect(taxPosition.tax, 6075);
    });

    test('80,000 2018 30000 other', () {
      dividend.income= 80000;
      earnings.income= 30000;
      expect(taxPosition.tax, 27825);
    });

    test('100,000 2018 30000 other', () {
      dividend.income= 100000;
      earnings.income= 30000;
      expect(taxPosition.tax, 36875);
    });

    test('50,000 2018 150000 other', () {
      dividend.income= 50000;
      earnings.income= 150000;
      expect(taxPosition.tax, 70445);
    });

    test('60,000 2018 no other income', () {
      dividend.income= 60000;
      earnings.income= 0;
      expect(taxPosition.tax, 7012.50);
    });

    test('100,000 2018 no other income', () {
      dividend.income= 100000;
      expect(taxPosition.tax, 20012.50);
    });

    test('200,000 2018 no other income', () {
      dividend.income= 200000;
      expect(taxPosition.tax, 59050);
    });


  });

}

void incomeTaxEnglandSavings2018(){

  Person person;
  PersonalTaxPosition taxPosition;
  Income earnings;
  Income dividend;
  Income savings;

  group('Income tax savings 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      
      taxPosition = person.taxYear(2018);

      Employment employment = new Employment(person);
      earnings = employment.getIncome(taxPosition);

      ShareHolding investment = new ShareHolding(person);
      dividend = investment.getIncome(taxPosition);

      Savings deposit = new Savings(person);
      savings = deposit.getIncome(taxPosition);
    });


    test('4,000 2018 savings', () {
      dividend.income= 0;
      earnings.income= 0;
      savings.income= 4000;
      expect(taxPosition.tax, 0);
    });

    test('40,000 2018 savings', () {
      earnings.income= 6000;
      savings.income= 4000;
      dividend.income= 5000;
      expect(taxPosition.tax, 0);
    });

    test('10,000 2018 savings', () {
      earnings.income= 10000;
      savings.income= 5000;
      dividend.income= 20000;

      expect(taxPosition.tax, 1625); //wrong by £200
    });

    test('60,000 2018 savings', () {
      earnings.income= 10000;
      savings.income= 2000;
      dividend.income= 60000;

      expect(taxPosition.tax, 10750); // wrong by £200
    });

    test('20,000 2018 savings', () {
      earnings.income= 10000;
      savings.income= 6000;
      dividend.income= 4000;

      expect(taxPosition.tax, 200); //wrong by £700
    });

    test('80,000 2018 savings', () {
      dividend.income= 80000;
      earnings.income= 30000;
      expect(taxPosition.tax, 27825);
    });

    test('100,000 2018 savings', () {
      dividend.income= 100000;
      earnings.income= 30000;
      expect(taxPosition.tax, 36875);
    });

    test('50,000 2018 savings', () {
      dividend.income= 50000;
      earnings.income= 150000;
      expect(taxPosition.tax, 70445);
    });

    test('60,000 2018 savings', () {
      dividend.income= 60000;
      earnings.income= 0;
      expect(taxPosition.tax, 7012.50);
    });

    test('100,000 2018 savings', () {
      dividend.income= 100000;
      expect(taxPosition.tax, 20012.50);
    });

    test('200,000 2018 savings', () {
      dividend.income= 200000;
      expect(taxPosition.tax, 59050);
    });


  });

}

void incomeTaxScotland2019(){

  Person person;
  PersonalTaxPosition taxPosition;

  Income earnings;
  Income dividend;
  Income savings;

  group('Income tax Scotland 2019', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = true;

      taxPosition = person.taxYear(2019);

      Employment employment = new Employment(person);
      earnings = new Income(employment, taxPosition);

      ShareHolding investment = new ShareHolding(person);
      dividend = new Income(investment, taxPosition);

      Savings deposit = new Savings(person);
      savings = new Income(deposit, taxPosition);
    });


    test('20,000 2019 scotland', () {
      earnings.income= 20000;
      expect(taxPosition.tax, 1610);
    });

    test('45,000 2019 scotland', () {
      earnings.income= 45000;
      expect(taxPosition.tax, 7134);
    });

    test('90,000 2019 scotland', () {
      earnings.income= 90000;
      expect(taxPosition.tax, 25584);
    });

    test('200,000 2019 scotland', () {
      earnings.income= 200000;
      expect(taxPosition.tax, 78042.50);
    });


  });

}

void nationalInsuranceEarnings() {

  Person person;
  PersonalTaxPosition taxPosition;

  Income earnings;
  Income dividend;
  Income savings;


  group('National insurance earnings', () {

    setUp(() {
      person = new Person();
      person.scotland = false;

      taxPosition = person.taxYear(2018);

      Employment employment = new Employment(person);
      earnings = new Income(employment, taxPosition);

      ShareHolding investment = new ShareHolding(person);
      dividend = new Income(investment, taxPosition);

      Savings deposit = new Savings(person);
      savings = new Income(deposit, taxPosition);
    });

    test('5,000 2018 employee', () {
      earnings.income= 5000;
      taxPosition.tax;
      expect(taxPosition.nicClass1p, 0);
    });

    test('5,000 2018 employer', () {
      earnings.income= 5000;
      taxPosition.tax;
      expect(taxPosition.nicClass1s, 0);
    });

    test('20,000 2018 employee', () {
      earnings.income= 20000;
      taxPosition.tax;
      expect(taxPosition.nicClass1p, 1420.8);

    });

    test('20,000 2018 employer', () {
      earnings.income= 20000;
      taxPosition.tax;
      expect(taxPosition.nicClass1s, 1633.92);
    });

    test('45,000 2018 employee', () {
      earnings.income= 45000;
      taxPosition.tax;
      expect(taxPosition.nicClass1p, 4420.8);

    });

    test('45,000 2018 employer', () {
      earnings.income= 45000;
      taxPosition.tax;
      expect(taxPosition.nicClass1s, 5083.92);
    });

    test('90,000 2018 employee', () {
      earnings.income= 90000;
      taxPosition.tax;
      expect(taxPosition.nicClass1p, 5320.8);

    });

    test('90,000 2018 employer', () {
      earnings.income= 90000;
      taxPosition.tax;
      expect(taxPosition.nicClass1s, 11293.92);
    });


  });
}

void nationalInsuranceTrade() {

  Person person;
  PersonalTaxPosition taxPosition;

  Income earnings;
  Income dividend;
  Income savings;
  Income trade;

  group('National insurance trade', () {

    setUp(() {
      person = new Person();
      person.scotland = false;

      taxPosition = person.taxYear(2018);

      Employment employment = new Employment(person);
      earnings = new Income(employment, taxPosition);

      ShareHolding investment = new ShareHolding(person);
      dividend = new Income(investment, taxPosition);
      Savings deposit = new Savings(person);
      savings = new Income(deposit, taxPosition);

      Trade business = new Trade(person);
      trade = new Income(business, taxPosition);
    });

    test('5,000 2018 trade', () {
      trade.income= 5000;
      taxPosition.tax;
      expect(taxPosition.nicClass4, 0);
    });

    test('20,000 2018 trade', () {
      trade.income= 20000;
      taxPosition.tax;
      expect(taxPosition.nicClass4, 1065.24);

    });


    test('45,000 2018 trade', () {
      trade.income= 45000;
      taxPosition.tax;
      expect(taxPosition.nicClass4, 3315.24);

    });

    test('90,000 2018 trade', () {
      trade.income= 90000;
      taxPosition.tax;
      expect(taxPosition.nicClass4, 4215.24);

    });


  });
}

void capitalGains() {

  Person person;
  PersonalTaxPosition taxPosition;

  Income earnings;
  Income dividend;
  Income savings;
  Income trade;


  group('Capital gains 2018', () {

    person;

    setUp(()  {
     person = Entity.get(Entity.INDIVIDUAL);
     person.scotland = false;

     taxPosition = person.taxYear(2018);

     Employment employment = new Employment(person);
     earnings = new Income(employment, taxPosition);

     ShareHolding investment = new ShareHolding(person);
     dividend = new Income(investment, taxPosition);

     Savings deposit = new Savings(person);
     savings = new Income(deposit, taxPosition);

     Trade business = new Trade(person);
     trade = new Income(business, taxPosition);
     
    });


    test('gain proceeds 10000 cost 5000 improvement 1500', () {

      ChargeableAsset asset = new ChargeableAsset(person);
      asset.cost = 5000;
      asset.proceeds = 10000;
      asset.addImprovement(new Improvement(1000));
      asset.addImprovement(new Improvement(500));

      expect(asset.taxableGain, 3500);

    });

    test('One asset with gain of 5000', () {

      ChargeableAsset asset = new ChargeableAsset(person);
      asset.cost = 5000;
      asset.proceeds = 10000;
      asset.saleDate = new Date(5,4,18);
      person.assets.add(asset);
      taxPosition.tax;

      expect(person.taxYear(2018).totalGains, 5000);
    });

    test('One asset with gain of 13000', () {


      // gain 0f 13000
      ChargeableAsset asset01 = new ChargeableAsset(person);
      asset01.cost = 2000;
      asset01.proceeds = 15000;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.cost = 4000;
      asset02.addImprovement(new Improvement(1000));
      asset02.proceeds = 1000;
      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);


      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.cost = 5000;
      asset03.proceeds = 10000;
      asset03.saleDate = new Date(6,4,18);
      person.assets.add(asset03);
      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 13000);
      expect(person.taxYear(2018).capitalLosses, 4000);

    });

    test('Mixed gains and losses 1', () {

    person.taxYear(2018).capitalLossBroughtForward = 500;

      // gain 0f 13000
      ChargeableAsset asset01 = new ChargeableAsset(person);
      asset01.cost = 2000;
      asset01.proceeds = 15000;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.cost = 5000;
      asset02.proceeds = 1000;
      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);


      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.cost = 5000;
      asset03.proceeds = 10000;
      asset03.saleDate = new Date(6,4,18);
      person.assets.add(asset03);
    person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 13000);
      expect(person.taxYear(2018).capitalLosses, 4000);
      expect(person.taxYear(2018).netGains, 9000);
      expect(person.taxYear(2018).capitalLossCarriedForward, 500);
    });

    test('Mixed gains and losses 2', () {

      person.taxYear(2018).capitalLossBroughtForward = 500;

      // gain 0f 15500
      ChargeableAsset asset01 = new ChargeableAsset(person);
      asset01.cost = 2000;
      asset01.proceeds = 17500;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.cost = 5000;
      asset02.proceeds = 1000;
      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);


      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.cost = 5000;
      asset03.proceeds = 10000;
      asset03.saleDate = new Date(6,4,18);
      person.assets.add(asset03);

      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 15500);
      expect(person.taxYear(2018).capitalLosses, 4000);
      expect(person.taxYear(2018).netGains, 11300);
      expect(person.taxYear(2018).capitalLossCarriedForward, 300);
      expect(person.taxYear(2018).taxableGains, 0);
    });

    test('Residential Property', () {

      // gain 0f 15500
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.cost = 2000;
      asset01.proceeds = 17500;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);

      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 15500);
      expect(person.taxYear(2018).capitalLosses, 0);
      expect(person.taxYear(2018).netGains, 15500);
      expect(person.taxYear(2018).taxableGains, 4200);
      expect(person.taxYear(2018).capitalLossCarriedForward, 0);
    });

    test('Residential Property', () {

      // gain 0f 15500
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.cost = 2000;
      asset01.proceeds = 17500;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);
      earnings.income= 20000;

      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 15500);
      expect(person.taxYear(2018).capitalLosses, 0);
      expect(person.taxYear(2018).netGains, 15500);
      expect(person.taxYear(2018).taxableGains, 4200);
      expect(person.taxYear(2018).capitalLossCarriedForward, 0);
      expect(person.taxYear(2018).basicRateAvailable, 25000);
    });

    test('Loss allocation 1', () {
      earnings.income= 20000;
      // gain 0f 10000 res
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.proceeds = 10000;
      asset01.cost = 0;

      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // gain 0f 11000 non res
      ChargeableAsset asset02 = new Investment(person);
      asset02.proceeds = 11000;
      asset02.cost = 0;

      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);
      earnings.income= 20000;

      // loss pf 15000
      ResidentialProperty asset20 = new ResidentialProperty(person);
      asset20.proceeds = 0;
      asset20.cost = 15000;

      asset20.saleDate = new Date(5,4,18);
      person.assets.add(asset20);
      earnings.income= 20000;
      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 21000);
      expect(person.taxYear(2018).capitalLosses, 15000);
      expect(person.taxYear(2018).netGains, 6000);
      expect(person.taxYear(2018).taxableGains, 0);
      expect(person.taxYear(2018).capitalLossCarriedForward, 0);
      expect(person.taxYear(2018).basicRateAvailable, 25000);
      expect(asset01.lossAllocated, 10000);
      expect(asset02.lossAllocated, 5000);
      expect(person.taxYear(2018).tax, 1700);
    });

    test('Loss allocation 2', () {

      earnings.income= 15000;
      person.taxYear(2018).capitalLossBroughtForward = 15000;
      
      // gain 0f 4000 res
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.proceeds = 4000;
      asset01.cost = 0;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);
      

      // gain 0f 5000  res
      ResidentialProperty asset02 = new ResidentialProperty(person);
      asset02.proceeds = 5000;
      asset02.cost = 0;

      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);

      // gain 0f 6000 non res
      ChargeableAsset asset03 = new Investment(person);
      asset03.proceeds = 6000;
      asset03.cost = 0;

      asset03.saleDate = new Date(5,4,18);
      person.assets.add(asset03);

      // gain 0f 8000 ent
      ChargeableAsset asset04 = new Investment(person);
      asset04.proceeds = 8000;
      asset04.cost = 0;

      asset04.saleDate = new Date(5,4,18);
      asset04.entrepreneurRelief = true;

      person.assets.add(asset04);

      // gain 0f 12000 ent
      ChargeableAsset asset05 = new Investment(person);
      asset05.proceeds = 12000;
      asset05.cost = 0;

      asset05.saleDate = new Date(5,4,18);
      asset04.entrepreneurRelief = true;
      person.assets.add(asset05);


      // loss pf 8000
      ResidentialProperty asset20 = new ResidentialProperty(person);
      asset20.proceeds = 0;
      asset20.cost = 8000;

      asset20.saleDate = new Date(5,4,18);
      person.assets.add(asset20);

      // loss pf 4000
      ResidentialProperty asset21 = new ResidentialProperty(person);
      asset21.proceeds = 0;
      asset21.cost = 4000;

      asset21.saleDate = new Date(5,4,18);
      person.assets.add(asset21);
      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 35000);
      expect(person.taxYear(2018).capitalLosses, 12000);
      expect(person.taxYear(2018).netGains, 11300);
      expect(person.taxYear(2018).taxableGains, 0);
      expect(person.taxYear(2018).capitalLossCarriedForward, 3300);
      expect(person.taxYear(2018).basicRateAvailable, 30000);
      expect(asset04.lossAllocated + asset05.lossAllocated, 8700);
      expect(person.taxYear(2018).tax, 700);

    });

    test('Basic Rate allocatoin 1', () {

      earnings.income= 0;
      person.taxYear(2018).capitalLossBroughtForward = 2300;

      // gain 0f 20000 res
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.proceeds = 20000;
      asset01.cost = 0;
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);


      // gain 0f 50000 non res
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.proceeds = 50000;
      asset02.cost = 0;

      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);

      // gain 0f 8000 ent
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.proceeds = 8000;
      asset03.saleDate = new Date(5,4,18);
      asset03.entrepreneurRelief = true;
      asset03.cost = 0;
      person.assets.add(asset03);

      person.taxYear(2018).tax;
      expect(person.taxYear(2018).totalGains, 78000);
      expect(person.taxYear(2018).capitalLosses, 0);
      expect(person.taxYear(2018).netGains, 75700);
      expect(person.taxYear(2018).taxableGains, 64400);
      expect(person.taxYear(2018).capitalLossCarriedForward, 0);
      expect(person.taxYear(2018).basicRateAvailable, 33500);
      expect(person.taxYear(2018).tax, 9242);

    });

    test('Main residence relief - no losses allowed', () {

      // loss on main residence
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.proceeds = 0;
      asset01.cost = 20000;
      asset01.addResidencePeriod(new Period(new Date(31,1,17), new Date(5,4,18)));
      asset01.purchaseDate = new Date(1,1,17);
      asset01.saleDate = new Date(5,4,18);
      person.assets.add(asset01);

      ResidentialProperty asset02 = new ResidentialProperty(person);
      asset02.proceeds = 20000;
      asset02.cost = 0;
      asset01.purchaseDate = new Date(1,1,17);
      asset02.saleDate = new Date(5,4,18);
      person.assets.add(asset02);

      person.taxYear(2018).tax;
      expect(person.taxYear(2018).totalGains, 20000);
      expect(person.taxYear(2018).capitalLosses, 0);
      expect(person.taxYear(2018).netGains, 20000);
      expect(person.taxYear(2018).taxableGains, 8700);
      expect(person.taxYear(2018).capitalLossCarriedForward, 0);
      expect(person.taxYear(2018).basicRateAvailable, 33500);
      expect(person.taxYear(2018).tax, 1566);

    });

    test('Main residence relief - last 18 months', () {

      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.proceeds = 30000;
      asset01.cost = 0;
      asset01.purchaseDate = new Date(13,1,15);
      asset01.saleDate = new Date(5,4,18);
      asset01.addResidencePeriod(new Period(new Date(13,1,15), new Date(5,4,18)));
      person.assets.add(asset01);

      ResidentialProperty asset02 = new ResidentialProperty(person);
      asset02.proceeds = 20000;
      asset02.cost = 0;
      asset02.purchaseDate = new Date(1,7,16);
      asset02.saleDate = new Date(31,12,17);
      asset02.addResidencePeriod(new Period(new Date(1,1,18), new Date(5,4,18)));
      person.assets.add(asset02);

      person.taxYear(2018).tax;
      expect(person.taxYear(2018).totalGains, 0);
      expect(person.taxYear(2018).capitalLosses, 0);
      expect(person.taxYear(2018).netGains, 0);
      expect(person.taxYear(2018).taxableGains, 0);
      expect(person.taxYear(2018).capitalLossCarriedForward, 0);
      expect(person.taxYear(2018).basicRateAvailable, 33500);
      expect(person.taxYear(2018).tax, 0);

    });

    test('Main residence relief - periods', () {

      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.proceeds = 100000;
      asset01.cost = 0;
      asset01.purchaseDate = new Date(13,1,15);
      asset01.saleDate = new Date(5,4,18);
      asset01.addResidencePeriod(new Period(new Date(13,1,16), new Date(5,4,18)));
      person.assets.add(asset01);

      expect(asset01.taxableGain, 30985);

    });

    test('Indexation for company gains', () {
      Company company = new Company();

      Investment asset01 = new Investment(company);
      asset01.proceeds = 100000;
      asset01.cost = 20000;
      asset01.purchaseDate = new Date(1,12,90);
      asset01.saleDate = new Date(1,3,16);

      expect(asset01.taxableGain, 59800);
    });



  });
}

void incomeAndExpenditure(){

  IncomeAndExpenditure incomeAndExpenditure;
  IncomeAndExpenditureProperty propertyAccount;
  Person person = new Person();

  setUp(() {

    Date start = new Date (6,4,17);
    Date end = new Date(5,4,18);

    Period period = new Period(start, end);
    incomeAndExpenditure = new IncomeAndExpenditure(period, person);
    propertyAccount = new IncomeAndExpenditureProperty(period, person);
  });

  group('Income and Expenditure', (){

    test('Simple income and Expenditure', () {

      expect(incomeAndExpenditure.profit, 0);
    });

    test('Wrong end date', () {

      Period wrongPeriod = new Period(new Date(6,4,17), new Date(4,4,18));
      IncomeAndExpenditure wrongIncomeAndExpenditure = new IncomeAndExpenditure(wrongPeriod, person);

      expect(wrongIncomeAndExpenditure.profit, 0);
    });

    test('Simple income and Expenditure', () {

      Date date = new Date(5,4,18);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      incomeAndExpenditure.add(rent1);
      incomeAndExpenditure.add(rent2);
      incomeAndExpenditure.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);

      incomeAndExpenditure.add(repairs);


      expect(incomeAndExpenditure.profit, 2500);
    });

    test('More complex income and Expenditure', () {

      Date date = new Date(5,4,18);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      incomeAndExpenditure.add(rent1);
      incomeAndExpenditure.add(rent2);
      incomeAndExpenditure.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);

      incomeAndExpenditure.add(repairs);


      expect(incomeAndExpenditure.profit, 2500);
    });

    test('Same but with residential property', () {

      Date date = new Date(5,4,18);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      propertyAccount.add(rent1);
      propertyAccount.add(rent2);
      propertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);

      propertyAccount.add(repairs);


      expect(propertyAccount.profit, 2500);
    });

    test('Residential property with interest deduction', () {

      Date date = new Date(5,4,18);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      propertyAccount.add(rent1);
      propertyAccount.add(rent2);
      propertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);
      Interest interest = new Interest(date, 'interet', 1000);

      propertyAccount.add(repairs);
      propertyAccount.add(interest);

      expect(propertyAccount.profit, 1750);
      expect(propertyAccount.taxCredit, 50);
    });

    test('Residential property with interest deduction 2019', () {

      Date date = new Date(5,4,19);
      propertyAccount.period.start = new Date(6,4,18);
      propertyAccount.period.end = new Date(5,4,19);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      propertyAccount.add(rent1);
      propertyAccount.add(rent2);
      propertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);
      Interest interest = new Interest(date, 'interet', 1000);

      propertyAccount.add(repairs);
      propertyAccount.add(interest);

      expect(propertyAccount.profit, 2000);
      expect(propertyAccount.taxCredit, 100);
    });

    test('Residential property with interest deduction 2020', () {

      Date date = new Date(5,4,19);
      propertyAccount.period.start = new Date(6,4,19);
      propertyAccount.period.end = new Date(5,4,20);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      propertyAccount.add(rent1);
      propertyAccount.add(rent2);
      propertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);
      Interest interest = new Interest(date, 'interet', 1000);

      propertyAccount.add(repairs);
      propertyAccount.add(interest);

      expect(propertyAccount.profit, 2250);
      expect(propertyAccount.taxCredit, 150);
    });

    test('Residential property with interest deduction 2021', () {

      Date date = new Date(5,4,19);
      propertyAccount.period.start = new Date(6,4,20);
      propertyAccount.period.end = new Date(5,4,21);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      propertyAccount.add(rent1);
      propertyAccount.add(rent2);
      propertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);
      Interest interest = new Interest(date, 'interet', 1000);

      propertyAccount.add(repairs);
      propertyAccount.add(interest);

      expect(propertyAccount.profit, 2500);
      expect(propertyAccount.taxCredit, 200);
    });

    test('Residential property with interest deduction 2021 company', () {
      Company company = new Company();
      Date start = new Date (6,4,17);
      Date end = new Date(5,4,18);

      Period period = new Period(start, end);
      IncomeAndExpenditureProperty coPropertyAccount = new IncomeAndExpenditureProperty(period, company);

      Date date = new Date(5,4,19);
      coPropertyAccount.period.start = new Date(6,4,20);
      coPropertyAccount.period.end = new Date(5,4,21);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      coPropertyAccount.add(rent1);
      coPropertyAccount.add(rent2);
      coPropertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);
      Interest interest = new Interest(date, 'interet', 1000);

      coPropertyAccount.add(repairs);
      coPropertyAccount.add(interest);

      expect(coPropertyAccount.profit, 1500);
      expect(coPropertyAccount.taxCredit, 0);
    });

    test('Residential property with interest deduction 2021 company', () {
      Company company = new Company();
      Date start = new Date (6,4,17);
      Date end = new Date(5,4,18);

      Period period = new Period(start, end);
      IncomeAndExpenditureProperty coPropertyAccount = new IncomeAndExpenditureProperty(period, company);

      Date date = new Date(5,4,19);
      coPropertyAccount.period.start = new Date(6,4,20);
      coPropertyAccount.period.end = new Date(5,4,21);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      coPropertyAccount.add(rent1);
      coPropertyAccount.add(rent2);
      coPropertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);
      Interest interest = new Interest(date, 'interet', 1000);

      coPropertyAccount.add(repairs);
      coPropertyAccount.add(interest);

      expect(coPropertyAccount.profit, 1500);
      expect(coPropertyAccount.taxCredit, 0);
    });

    test('Residential property 2020 added to Activities', () {

      Date date = new Date(5,4,19);
      propertyAccount.period.start = new Date(6,4,19);
      propertyAccount.period.end = new Date(5,4,20);

      IncomeAccount rent1 = new IncomeAccount(date, 'rent', 1000);
      IncomeAccount rent2 = new IncomeAccount(date, 'rent', 3000);
      IncomeAccount rent3 = new IncomeAccount(date, 'rent', 500);

      propertyAccount.add(rent1);
      propertyAccount.add(rent2);
      propertyAccount.add(rent3);

      ExpenditureAccount repairs = new ExpenditureAccount(date, 'repairs', 2000);
      Interest interest = new Interest(date, 'interet', 1000);

      propertyAccount.add(repairs);
      propertyAccount.add(interest);

      Person person = new Person();
      PropertyBusiness business = new PropertyBusiness(person);
      business.accounts.add(propertyAccount);
      PersonalTaxPosition taxPosition = person.taxYear(2020);
      PropertyIncome rentals = new PropertyIncome(business, taxPosition);

      person.taxYear(2020).tax;

      expect(propertyAccount.profit, 2250);
      expect(propertyAccount.taxCredit, 150);
      expect(rentals.income, 2250);
      expect(rentals.taxCredit, 150);
      expect(taxPosition.propertyIncome, 2250);
    });



  });


}

void corporationTax(){

 Company company;
 Income other;
 CompanyTaxPosition taxPosition;

  setUp(() {
    company = new Company();

    Date first = new Date(1,10,19);
    Date second = new Date(30,9,20);
    Period period = new Period(first, second);

    taxPosition = company.accountingPeriod(period);

    Other activity = new Other(company);
    other = new Income(activity, taxPosition);

  });

  group('Corporation Tax ', (){

    test('Accounting period', () {

      other.income = 10000;

      expect(taxPosition.tax, 1795.07);
    });

    test('Accounting period', () {

      ChargeableAsset asset01 = new ChargeableAsset(company);
      asset01.saleDate = new Date(30,9,20);
      asset01.proceeds = 10000;
      asset01.cost = 5000;
      company.assets.add(asset01);

      other.income = 10000;

      expect(taxPosition.tax, 2692.60);
      expect(taxPosition.gains, 5000);
    });

    test('Accounting period', () {

      Date first = new Date(1,4,16);
      Date second = new Date(31,3,17);
      Period period = new Period(first, second);
      company.accountingPeriod(period);

      first = new Date(1,4,17);
      second = new Date(31,3,18);
      period = new Period(first, second);
      company.accountingPeriod(period);

      expect(company.lastAccountingPeriod().period.end.year, 2018);
      expect(company.taxPeriods.length, 2);

    });



  });


}
