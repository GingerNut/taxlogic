import 'package:taxlogic/src/activity/lending/loan.dart';
import 'package:taxlogic/src/assets/asset.dart';

import 'package:taxlogic/src/assets/transaction/property_transaction.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/game/move/property_business/transfer_property.dart';
import 'package:taxlogic/taxlogic.dart';
import 'package:test/test.dart';

void main() {
  game();
  dates();
  transactions();
  periods();
  histories();
  rateTable();
  taxdata();
  incomeTaxEngland2017();
  incomeTaxEngland2018();
  incomeTaxEnglandDividend2018();
  incomeTaxEnglandSavings2018();
  incomeTaxScotland2019();
  BIK_2018();
  lending();
  nationalInsuranceEarnings();
  nationalInsuranceTrade();
  capitalGains();
  incomeAndExpenditure();
  corporationTax();
  companySecretarial();
  stampDuty();
}

void game(){

  group('Game elements ', (){

    String person1id = 'Harry';
    Date person1birthday = new Date(21,9,62);
    String person2id = 'Gerry';
    String company1Id = 'Company 1';

    String employment1id = 'Job';
    Game game;

    setUp(() {
      game = new Game();
    });

    test('Employment started and cessated with termination payment ', (){
      game.makeMove(new CreateIndividual(new Date(6,4,17), person1id ));
      game.makeMove(new StartEmployment(person1id, employment1id, new Date(6,10,17), 80000));

      Person person = game.position.getEntityByName(person1id);

      expect(person.taxYear(2018).tax, 5678.08);
      expect(person.activities[0].annualIncome.valueAt(new Date(6,4,17)), 0);
      expect(person.activities[0].annualIncome.valueAt(new Date(5,10,17)), 0);
      expect(person.activities[0].annualIncome.valueAt(new Date(6,10,17)), 80000);

      expect(person.taxYear(2019).earningsIncome , 80000);

      game.makeMove(new PaychangeEmployment(employment1id, new Date(6,4,18), 90000));
      game.makeMove(new EndEmployment(person1id, employment1id, new Date(6,10,18), 10000)); // 18/19 inc ~ £55k (£45k plus £10 temination paymnet

      PersonalTaxPosition taxPosition19 = person.taxYear(2019);
      expect(taxPosition19.tax, 10409.32);
      expect(taxPosition19.earningsIncome, 55123.29);

      PersonalTaxPosition taxPosition20 = person.taxYear(2020);
      expect(taxPosition20.tax,0);
      expect(taxPosition20.earningsIncome, 0);
    });

    test('Company cars ', () {
      String carId = 'VW UP';

        game.makeMove(new CreateIndividual(person1birthday, person1id));
        game.makeMove(new StartEmployment(person1id, employment1id, new Date(1,6,16), 20000));
        game.makeMove(new EmploymentCompanyCar(person1id, employment1id, carId, new Date(1,6,16), new Date(1,6,16), 25000 , 130));

        Person person = game.position.getEntityByName(person1id);

        PersonalTaxPosition taxPosition = person.taxYear(2018);
        taxPosition.tax;
        expect(taxPosition.earningsIncome, 26250);

    });

    test('Property business ', () {

      var property1 = new ResidentialProperty(null)
      .. setRent(50000)
          ..setInterest(30000);

      game.makeMove(new CreateIndividual(person1birthday, person1id));
      Person Harry = game.position.getEntityByName(person1id);
      expect(Harry.assets.length, 0);
      expect((Harry.activities.length), 0);

      game.makeMove(new TransferRentalProperty(null, person1id, property1, new Date(6,4,17), 500000));

      PersonalTaxPosition taxPosition = Harry.taxYear(2018);

      taxPosition.tax;
      expect(Harry.assets.length, 2);
      expect((Harry.activities.length), 1);
      expect(taxPosition.tax, 1700);

      game.makeMove(new CreateCompany(new Date(6,4,18), company1Id));
      game.makeMove(new TransferRentalProperty(person1id, company1Id, property1, new Date(1,10,18), 500000));

      Company company = game.position.getEntityByName(company1Id);

      CompanyAccountingPeriod companyTaxPosition = company.accountingPeriod(company.defaultPeriod.end(2019));



      expect(company.assets.length, 2);
      expect(companyTaxPosition.tax, 1894.80);

    });

    test('Sale of property businesss ', () {

      String propertyId = 'property';

      var property1 = new ResidentialProperty(null)
        ..name = propertyId
        .. setRent(50000)
        ..setInterest(30000);

      game.makeMove(new CreateIndividual(person1birthday, person1id));
      Person Harry = game.position.getEntityByName(person1id);
      expect((Harry.activities.length), 0);

      game.makeMove(new TransferRentalProperty(null, person1id, property1, new Date(6,4,17), 500000));
      game.makeMove(new CreateCompany(new Date(6,4,17), company1Id));
      game.makeMove(new TransferRentalProperty(person1id, company1Id, property1, new Date(1,10,17), 520000)); // £20k gain

      PersonalTaxPosition taxPosition = Harry.taxYear(2018);
      taxPosition.tax;

      expect(Harry.assets.length, 2);
      expect((Harry.activities.length), 1);
      expect(property1.taxableGain(Harry), 20000);

      expect(taxPosition.tax, 1566); // cgt £1,566 = 20000 at 18%

      Company company = game.position.getEntityByName(company1Id);
      CompanyAccountingPeriod companyTaxPosition = company.accountingPeriod(company.defaultPeriod.end(2018));
      expect(companyTaxPosition.tax, 1894.80);

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

void transactions(){

  group('Transactions ', (){

    test('simple transfer of asset from one person to another', () {

      Date buy = new Date (6,4,17); //  for 100000
      Date transfer = new Date(1,6,18);  // for 150000
      Date sell = new Date(1,10,18); // for 200000

      Person person1 = new Person();
      Person person2 = new Person();
      Property property = new Property(person1)
      ..name = 'The Glades '
      ..setAcquisitionDate(person1, buy)
      ..setAcquisitionConsideration(person1, 100000);

      new Transaction()
      ..asset = property
      ..seller = person1
      ..buyer = person2
        ..consideration = 140000
      ..date = transfer
      ..go();

      new Transaction()
      ..asset = property
      ..seller = person2
        ..consideration = 200000
      ..date = sell
      ..go();

      expect(person1.assets.length, 2); //property itself and property business
      expect(property.acquisitionDate(person1), buy);
      expect(property.acquisitionConsideration(person1), 100000);

      expect(property.disposalDate(person1), transfer);
      expect(property.disposalConsideration(person1), 140000);
      person1.taxYear(2019).tax;
      expect(person1.taxYear(2019).taxableGains, 40000 - 11700);

      expect(person2.assets.length, 2); //property itself and property business
      expect(property.acquisitionDate(person2), transfer);
      expect(property.acquisitionConsideration(person2), 140000);
      expect(property.disposalDate(person2), sell);
      expect(property.disposalConsideration(person2), 200000);
      expect(property.taxableGain(person2), 60000);

      expect(property.transactions.events.length, 3);
    });

    test('purchase and sale by joint owners ', () {

      Date buy = new Date (6,4,17); //  for 100000
      Date sell = new Date(1,10,18); // for 200000

      var person1 = new Person()
        ..name = "harry";
      var person2 = new Person()
      ..name = 'Steve';

      var joint = new JointOwners.jointTenants(person1, person2);

      var property = new Property(joint)
        ..name = 'the glades'
        ..setAcquisitionDate(joint, buy)
        ..setAcquisitionConsideration(joint, 100000);

     new Transaction()
     ..asset = property
        ..seller = joint
        ..consideration = 200000
        ..date = sell
        ..go();

      expect(joint.assets.length, 0); //property itself and property business
      expect(person1.assets.length, 2); //property itself and property business
      expect(person2.assets.length, 2); //property itself and property business

      expect(property.acquisitionDate(person1), buy);
      expect(property.acquisitionDate(person2), buy);
      expect(property.acquisitionConsideration(person1), 50000);
      expect(property.acquisitionConsideration(person2), 50000);

      expect(property.disposalDate(person1), sell);
      expect(property.disposalDate(person2), sell);
      expect(property.disposalConsideration(person1), 100000);
      expect(property.disposalConsideration(person2), 100000);

      expect(property.taxableGain(person1), 50000);
      expect(property.taxableGain(person2), 50000);

    });


    test('simple transfer of asset from one person joint ownership between two other people', () {

      Date buy = new Date (6,4,17); //  for 100000
      Date transfer = new Date(1,6,18);  // for 150000
      Date sell = new Date(1,10,18); // for 200000

      var person1 = new Person()
      ..name = "harry";
      var person2 = new Person();
      var person3 = new Person();

      var joint = new JointOwners.jointTenants(person2, person3);

      var property = new Property(person1)
      ..name = 'the glades'
        ..setAcquisitionDate(person1, buy)
        ..setAcquisitionConsideration(person1, 100000);

      new Transaction()
      ..asset = property
        ..seller = person1
        ..buyer = joint
        ..consideration = 140000
        ..date = transfer
        ..go();

      new Transaction()
        ..asset = property
        ..seller = joint
        ..consideration = 200000
        ..date = sell
        ..go();

      expect(person1.assets.length, 2); //property itself and property business
      expect(property.acquisitionDate(person1), buy);

      expect(property.acquisitionConsideration(person1), 100000);
      expect(property.disposalDate(person1), transfer);
      expect(property.disposalConsideration(person1), 140000);
      expect(property.taxableGain(person1), 40000);

      expect(property.transactions.events.length, 5);
      expect(joint.assets.length, 0); //property itself and property business
      expect(person2.assets.length, 2);
      expect(person3.assets.length, 2);
      expect(property.acquisitionDate(person2), transfer);
      expect(property.acquisitionConsideration(person2), 70000);
      expect(property.acquisitionConsideration(person3), 70000);
      expect(property.disposalDate(person2), sell);
      expect(property.disposalConsideration(person2), 100000);
      expect(property.disposalConsideration(person3), 100000);
      expect(property.taxableGain(person2), 30000);
      expect(property.taxableGain(person3), 30000);

      expect(property.transactions.events.length, 5);

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

void histories(){

  NumHistory history = new NumHistory.fromList([
    new NumChange(new Date(6,4,08),50000),
    new NumChange(new Date(6,4,10),100000),
    new NumChange(new Date(6,4,12),25000),
    new NumChange(new Date(1,1,13),250000),
    new NumChange(new Date(6,4,14),500000),
    new NumChange(new Date(1,1,16),200000),
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

      expect(history.valueAt(new Date(1,1,14)), 250000);


    });

    test('Rate periods ', () {

      Date start = new Date(1,1,14);
      Date end = new Date(31,12,17);

      Period period = new Period(start, end);

      List<NumPeriod> ratePeriods = history.getRatePeriods(period);
     
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

      property.changeRent(amount1, date1);

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

      property.changeRent(amount1, date1);
      property.changeRent(amount2, date2);

      Date start = new Date(1,7,17);
      Date end = new Date(30,6,18);

      Period period = new Period(start, end);

      expect(property.rent(period), 12438.36);

    });

    test('Test default amount  ', () {

      NumHistory history = new NumHistory();
      history.set(5000);

      Date test = new Date(21,9,62);

      expect(history.valueAt(test), 5000);

    });

    test('name change  ', () {

      NameHistory history = new NameHistory();
      history.set('hello');
      history.add(new NameChange(new Date(1,1,17), 'goodbye'));

      Date test = new Date(21,9,62);
      Date test2 = new Date(2,1,17);

      expect((history.valueAt(test) as NameChange).name, 'hello');
      expect((history.valueAt(test2) as NameChange).name, 'goodbye');

    });

  });


}

void rateTable(){

  group('Rate histories ', (){

    test('Test ', () {

      NumTable table = new NumTable.fromList([
        new NumThreshold(0,0),
        new NumThreshold(50,1),
        new NumThreshold(100,2),
        new NumThreshold(150,3),
      ]);

      expect(table.valueAt(49), 0);
      expect(table.valueAt(50), 1);
      expect(table.valueAt(99), 1);
      expect(table.valueAt(100), 2);
      expect(table.valueAt(101), 2);
      expect(table.valueAt(149), 2);
      expect(table.valueAt(150), 3);
      expect(table.valueAt(155), 3);
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

    test('Company car rate ', () {

      expect(TaxData.CompanyCarRate(2018, Car.PETROL, 49), 0.09);
      expect(TaxData.CompanyCarRate(2018, Car.PETROL, 100), .19);
      expect(TaxData.CompanyCarRate(2018, Car.PETROL, 132), .25);
      expect(TaxData.CompanyCarRate(2018, Car.PETROL, 175), .34);
      expect(TaxData.CompanyCarRate(2018, Car.PETROL, 184), .35);
      expect(TaxData.CompanyCarRate(2018, Car.PETROL, 185), .37);
      expect(TaxData.CompanyCarRate(2018, Car.PETROL, 190), .37);

      expect(TaxData.CompanyCarRate(2018, Car.DIESEL, 49), .12);
      expect(TaxData.CompanyCarRate(2018, Car.DIESEL, 100), .22);
      expect(TaxData.CompanyCarRate(2018, Car.DIESEL, 132), .28);
      expect(TaxData.CompanyCarRate(2018, Car.DIESEL, 175), .37);
      expect(TaxData.CompanyCarRate(2018, Car.DIESEL, 184), .37);
      expect(TaxData.CompanyCarRate(2018, Car.DIESEL, 185), .37);
      expect(TaxData.CompanyCarRate(2018, Car.DIESEL, 190), .37);
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
  Company company = new Company();

  group('Income tax dividned 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      
      taxPosition = person.taxYear(2018);

      Employment employment = new Employment(person);
      earnings = new Income(employment, taxPosition);

      ShareHolding investment = new ShareHolding(null, null, null, person);
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

      ShareHolding investment = new ShareHolding(null, null, null, person);
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

      expect(taxPosition.tax, 1625);
    });

    test('60,000 2018 savings', () {
      earnings.income= 10000;
      savings.income= 2000;
      dividend.income= 60000;

      expect(taxPosition.tax, 10750);
    });

    test('20,000 2018 savings', () {
      earnings.income= 10000;
      savings.income= 6000;
      dividend.income= 4000;

      expect(taxPosition.tax, 200);
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

      ShareHolding investment = new ShareHolding(null, null, null, person);
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

void BIK_2018(){

  Person person;
  PersonalTaxPosition taxPosition;
  Employment employment;
  EmploymentIncome earnings;
  CompanyCar car;

  group('Benefits in kind 2018', ()
  {

    setUp(() {
      person = new Person();
      person.scotland = false;
      employment = new Employment(person);
      car = new CompanyCar();
      employment.annualIncome.set(20000);
      taxPosition = person.taxYear(2018);
      earnings = employment.getIncome(taxPosition);
    });


    test('Basic tax position with no BIKS', () {
      expect(taxPosition.tax, 1700);
    });

    test('car benefit', () {
      employment.companyCars.add(car);

      car
      ..engineType = Car.PETROL
        ..listPrice = 20000
        ..CO2 = 130;

     expect(car.benefit(taxPosition ), 5000);
       car.madeAvailable = new Date(1,6,17);
       expect(car.benefit(taxPosition ), 4232);
      expect(earnings.income , 24232);

      car.ceaseToBeAvailable = new Date(1,12,17);
      expect(car.benefit(taxPosition ), 2520);
      expect(earnings.income , 22520);

      car.engineType = Car.DIESEL;
      expect(car.benefit(taxPosition ), 2823);
      expect(earnings.income , 22823);

      car.CO2 = 200;
      expect(car.benefit(taxPosition ), 3730);
      expect(earnings.income , 23730);

      car.CO2 = 40;
      expect(car.benefit(taxPosition ), 1209);
     expect(earnings.income , 21209);

      car.engineType = Car.ELECTRIC;
      expect(car.benefit(taxPosition ), 907);
      expect(earnings.income , 20907);

    });





  });

}

void lending(){


  group('Income tax Scotland 2019', ()
  {

    Person person;

    setUp(() {
      person = new Person();
    });


    test('loan', () {
      Loan loan = new Loan(person)
          ..interest.set(0.05)
          ..principle.set(100000)
      ..taxDeductedAtSource = true;

      PersonalTaxPosition taxPosition = person.taxYear(2018);
      taxPosition.tax;
      expect(taxPosition.savingsIncome, 100000 * 0.05);
      expect(taxPosition.taxDeducted, 100000 * 0.05 * .2);
      expect(taxPosition.tax, 0 - 100000 * 0.05 * .2);

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

      ShareHolding investment = new ShareHolding(null, null, null, person);
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

      ShareHolding investment = new ShareHolding(null, null, null,person);
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
     person = new Person()
     ..name = 'Harry';
     person.scotland = false;

     taxPosition = person.taxYear(2018);

     Employment employment = new Employment(person);
     earnings = new Income(employment, taxPosition);

     ShareHolding investment = new ShareHolding(null, null, null, person);
     dividend = new Income(investment, taxPosition);

     Savings deposit = new Savings(person);
     savings = new Income(deposit, taxPosition);

     Trade business = new Trade(person);
     trade = new Income(business, taxPosition);
     
    });


    test('gain proceeds 10000 cost 5000 improvement 1500', () {

      ChargeableAsset asset = new ChargeableAsset(person);
      asset.setAcquisitionConsideration(person,  5000);
      asset.sell(person, new Date(5,4,18), 10000);
      asset.addImprovement(person, new Improvement(person, 1000));
      asset.addImprovement(person, new Improvement(person, 500));

      taxPosition.tax;

      expect(asset.taxableGain(person), 3500);
      expect(person.taxYear(2018).totalGains, 3500);

    });

    test('One asset with gain of 5000', () {

      ChargeableAsset asset = new ChargeableAsset(person);
      asset.setAcquisitionConsideration(person,  5000);
      asset.sell(person,  new Date(5,4,18) ,10000);

      taxPosition.tax;

      expect(person.taxYear(2018).totalGains, 5000);
    });

    test('One asset with gain of 13000', () {


      // gain 0f 13000
      ChargeableAsset asset01 = new ChargeableAsset(person);
      asset01.setAcquisitionConsideration(person,  2000);
      asset01.sell(person,  new Date(5,4,18), 15000);



      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.setAcquisitionConsideration(person,  4000);
      asset02.addImprovement(person, new Improvement(person, 1000));
      asset02.sell(person,  new Date(5,4,18) , 1000);

      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.setAcquisitionConsideration(person, 5000);
      asset03.sell(person, new Date(6,4,18), 10000);

      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 13000);
      expect(person.taxYear(2018).capitalLosses, 4000);

    });

    test('Mixed gains and losses 1', () {

    person.taxYear(2018).capitalLossBroughtForward = 500;

      // gain 0f 13000
      ChargeableAsset asset01 = new ChargeableAsset(person);
      asset01.setAcquisitionConsideration(person,  2000);
      asset01.sell(person, new Date(5,4,18),15000);



      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.setAcquisitionConsideration(person,  5000);
      asset02.sell(person,  new Date(5,4,18) , 1000);



      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.setAcquisitionConsideration(person,  5000);
      asset03.sell(person,  new Date(6,4,18), 10000);

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
      asset01.setAcquisitionConsideration(person,  2000);
      asset01.sell(person,  new Date(5,4,18), 17500);



      // loss of 4000
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.setAcquisitionConsideration(person,  5000);
      asset02.sell(person,  new Date(5,4,18), 1000);



      // outside the tax year
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.setAcquisitionConsideration(person,  5000);
      asset03.sell(person,  new Date(6,4,18), 10000);


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
      asset01.setAcquisitionConsideration(person,  2000);
      asset01.sell(person,  new Date(5,4,18), 17500);


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
      asset01.setAcquisitionConsideration(person,  2000);
      asset01.sell(person,  new Date(5,4,18), 17500);

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
      asset01.setAcquisitionConsideration(person,  0);
      asset01.sell(person,  new Date(5,4,18), 10000);



      // gain 0f 11000 non res
      ChargeableAsset asset02 = new Investment(person);
      asset02.setAcquisitionConsideration(person,  0);
      asset02.sell(person,  new Date(5,4,18), 11000);

      earnings.income= 20000;

      // loss pf 15000
      ResidentialProperty asset20 = new ResidentialProperty(person);

      asset20.setAcquisitionConsideration(person,  15000);
      asset20.sell(person,  new Date(5,4,18), 0);

      earnings.income= 20000;
      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 21000);
      expect(person.taxYear(2018).capitalLosses, 15000);
      expect(person.taxYear(2018).netGains, 6000);
      expect(person.taxYear(2018).taxableGains, 0);
      expect(person.taxYear(2018).capitalLossCarriedForward, 0);
      expect(person.taxYear(2018).basicRateAvailable, 25000);
      //expect(asset01.lossAllocated, 10000);
      //expect(asset02.lossAllocated, 5000);
      expect(person.taxYear(2018).tax, 1700);
    });

    test('Loss allocation 2', () {

      earnings.income= 15000;
      person.taxYear(2018).capitalLossBroughtForward = 15000;
      
      // gain 0f 4000 res
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.setAcquisitionConsideration(person,  0);
      asset01.sell(person,  new Date(5,4,18), 4000);

      

      // gain 0f 5000  res
      ResidentialProperty asset02 = new ResidentialProperty(person);
      asset02.setAcquisitionConsideration(person,  0);

      asset02.sell(person,  new Date(5,4,18), 5000);


      // gain 0f 6000 non res
      ChargeableAsset asset03 = new Investment(person);
      asset03.setAcquisitionConsideration(person,  0);
      asset03.sell(person,  new Date(5,4,18),6000);


      // gain 0f 8000 ent
      ChargeableAsset asset04 = new Investment(person);
      asset04.setAcquisitionConsideration(person,  0);
      asset04.sell(person,  new Date(5,4,18), 8000);
      asset04.entrepreneurRelief = true;



      // gain 0f 12000 ent
      ChargeableAsset asset05 = new Investment(person);
      asset05.setAcquisitionConsideration(person,  0);
      asset05.sell(person,  new Date(5,4,18), 12000);
      asset04.entrepreneurRelief = true;



      // loss pf 8000
      ResidentialProperty asset20 = new ResidentialProperty(person);
      asset20.setAcquisitionConsideration(person,  8000);
      asset20.sell(person,  new Date(5,4,18), 0);


      // loss pf 4000
      ResidentialProperty asset21 = new ResidentialProperty(person);
      asset21.setAcquisitionConsideration(person,  4000);
      asset21.sell(person,  new Date(5,4,18), 0);

      person.taxYear(2018).tax;

      expect(person.taxYear(2018).totalGains, 35000);
      expect(person.taxYear(2018).capitalLosses, 12000);
      expect(person.taxYear(2018).netGains, 11300);
      expect(person.taxYear(2018).taxableGains, 0);
      expect(person.taxYear(2018).capitalLossCarriedForward, 3300);
      expect(person.taxYear(2018).basicRateAvailable, 30000);
      //expect(asset04.lossAllocated + asset05.lossAllocated, 8700);
      expect(person.taxYear(2018).tax, 700);

    });

    test('Basic Rate allocatoin 1', () {

      earnings.income= 0;
      person.taxYear(2018).capitalLossBroughtForward = 2300;

      // gain 0f 20000 res
      ResidentialProperty asset01 = new ResidentialProperty(person);
      asset01.setAcquisitionConsideration(person,  0);
      asset01.sell(person,  new Date(5,4,18), 20000);



      // gain 0f 50000 non res
      ChargeableAsset asset02 = new ChargeableAsset(person);
      asset02.setAcquisitionConsideration(person,  0);
      asset02.sell(person,  new Date(5,4,18), 50000);


      // gain 0f 8000 ent
      ChargeableAsset asset03 = new ChargeableAsset(person);
      asset03.sell(person,  new Date(5,4,18), 8000);
      asset03.entrepreneurRelief = true;
      asset03.setAcquisitionConsideration(person,  0);


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
      asset01.setAcquisitionConsideration(person,  20000);
      asset01.addResidencePeriod(person, new Period(new Date(31,1,17), new Date(5,4,18)));
      asset01.setAcquisitionDate(person, new Date(1,1,17));
      asset01.sell(person,  new Date(5,4,18), 0);


      ResidentialProperty asset02 = new ResidentialProperty(person);
      asset02.setAcquisitionConsideration(person,  0);
      asset01.setAcquisitionDate(person, new Date(1,1,17));
      asset02.sell(person,  new Date(5,4,18), 20000);


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
      asset01.setAcquisitionConsideration(person,  0);
      asset01.setAcquisitionDate(person,  new Date(13,1,15));
      asset01.sell(person,  new Date(5,4,18), 30000);
      asset01.addResidencePeriod(person, new Period(new Date(13,1,15), new Date(5,4,18)));


      ResidentialProperty asset02 = new ResidentialProperty(person);
      asset02.setAcquisitionConsideration(person,  0);
      asset02.setAcquisitionDate(person,  new Date(1,7,16));
      asset02.sell(person,  new Date(31,12,17), 20000);
      asset02.addResidencePeriod(person, new Period(new Date(1,1,18), new Date(5,4,18)));


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
      asset01.setAcquisitionConsideration(person,  0);
      asset01.setAcquisitionDate(person,  new Date(13,1,15));
      asset01.sell(person,  new Date(5,4,18), 100000);
      asset01.addResidencePeriod(person, new Period(new Date(13,1,16), new Date(5,4,18)));


      expect(asset01.taxableGain(person), 30985);

    });

    test('Indexation for company gains', () {
      Company company = new Company();

      Investment asset01 = new Investment(company);
      asset01.setAcquisitionConsideration(company,  20000);
      asset01.setAcquisitionDate(company, new Date(1,12,90));
      asset01.sell(company,  new Date(1,3,16), 100000);

      expect(asset01.taxableGain(company), 59800);
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
      asset01.sell(company, new Date(30,9,20), 10000);
      asset01.setAcquisitionConsideration(company, 5000);


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


    });



  });


}

void companySecretarial(){

  setUp(() {

  });

  group('Company shares ', (){

    test('dividend payment', () {
      Company company = new Company();
      Person shareholder1; // 25%
      Person shareholder2; // 75%

      String name = 'ordinary';

      shareholder1 = new Person();
      shareholder2 = new Person();

      company.founder(shareholder1, 25, null);
      company.founder(shareholder2, 75, null);

      company.payDividend(new Date(1,6,16), 100000);
      company.payDividend(new Date(1,6,17), 50000);
      company.payDividend(new Date(1,9,17), 50000);
      company.payDividend(new Date(1,6,18), 100000);

      expect(company.shareCapital(name, null).dividends[0].amount, 100000);

      ShareHolding shareHolding1 = shareholder1.activities[0];
      expect(shareHolding1.sharesAt(name, null), 25);

      ShareHolding shareHolding2 = shareholder2.activities[0];
      expect(shareHolding2.sharesAt(name, null), 75);

      PersonalTaxPosition taxPosition1 = shareholder1.taxYear(2018);
      taxPosition1.tax;
      expect(taxPosition1.dividendIncome, 25000);
      expect(taxPosition1.tax, 637.50);

      PersonalTaxPosition taxPosition2 = shareholder2.taxYear(2018);
      taxPosition2.tax;
      expect(taxPosition2.dividendIncome, 75000);
      expect(taxPosition2.tax, 11887.50);

    });

    test('dividend with a transfer', () {
      Company company = new Company()
      .. name = 'company';
      Person shareholder1; // 25%
      Person shareholder2; // 75%
      Person shareholder3; // receives later

      shareholder1 = new Person()
      .. name = "person 1";
      shareholder2 = new Person()
      .. name = 'perons 2';
      shareholder3 = new Person()
      .. name = 'person 3';

      ShareHolding holding1 = company.founder(shareholder1, 25, null);
      ShareHolding holding2 = company.founder(shareholder2, 75,null);

      Date before = new Date(1,7,17);

      Date transfer = new Date(1,8,17);

      new ShareTransaction()
      ..asset = holding1
      ..numberOfShares = 25
        .. date = transfer
        ..seller = shareholder1
        ..buyer = shareholder3
        ..consideration = 50000
      ..go();


      String name = 'ordinary';

      company.payDividend(new Date(1,6,16), 100000);
      company.payDividend(new Date(1,6,17), 50000);
      company.payDividend(new Date(1,9,17), 50000);
      company.payDividend(new Date(1,6,18), 100000);

      expect(company.shareCapital('ordinary', null).dividends[0].amount, 100000);

      ShareHolding shareHolding1 = shareholder1.activities[0];
      ShareHolding shareHolding2 = shareholder2.activities[0];
      ShareHolding shareHolding3 = shareholder3.activities[0];
      expect(shareHolding1.sharesAt(name, before), 25);
      expect(shareHolding2.sharesAt(name, before), 75);
      expect(shareHolding3.sharesAt(name, before), 0);

      expect(shareHolding1.sharesAt(name, new Date(1,9,17)), 0);
      expect(shareHolding2.sharesAt(name, new Date(1,9,17)), 75);
      expect(shareHolding3.sharesAt(name, new Date(1,9,17)), 25);

      expect(shareHolding2.sharesAt(name, null), 75);

      PersonalTaxPosition taxPosition1 = shareholder1.taxYear(2018);
      taxPosition1.tax;
      expect(taxPosition1.dividendIncome, 12500);  // 25% of first div
      expect(taxPosition1.capitalGainsTax(), 4490);
      expect(taxPosition1.tax, 4490);

      PersonalTaxPosition taxPosition2 = shareholder2.taxYear(2018);
      taxPosition2.tax;
      expect(taxPosition2.dividendIncome, 75000); // 75% of both divs
      expect(taxPosition2.tax, 11887.50);

      PersonalTaxPosition taxPosition3 = shareholder3.taxYear(2018);
      taxPosition3.tax;
      expect(taxPosition3.dividendIncome, 12500);  // 25% of second div
      expect(taxPosition3.tax, 0);


    });

    test('dividend with a part transfer', () {
      Company company = new Company()
        .. name = 'company';
      Person shareholder1; // 25%
      Person shareholder2; // 75%
      Person shareholder3; // receives later

      shareholder1 = new Person()
        .. name = "person 1";
      shareholder2 = new Person()
        .. name = 'perons 2';
      shareholder3 = new Person()
        .. name = 'person 3';

      ShareHolding holding1 = company.founder(shareholder1, 25, null);
      ShareHolding holding2 = company.founder(shareholder2, 75, null);

      Date date = new Date(1,8,17);

      new ShareTransaction()
      ..asset = holding1
      ..numberOfShares = 25
      .. date = date
      ..seller = holding1.owner(date)
      ..buyer = shareholder3
      ..consideration = 100000
      ..go();


      String name = 'ordinary';

      company.payDividend(new Date(1,6,16), 100000);
      company.payDividend(new Date(1,6,17), 50000);
      company.payDividend(new Date(1,9,17), 50000);
      company.payDividend(new Date(1,6,18), 100000);

      expect(company.ordinaryShares.dividends[0].amount, 100000);

      ShareHolding shareHolding1 = shareholder1.activities[0];
      expect(shareHolding1.sharesAt(name, null), 25);

      ShareHolding shareHolding2 = shareholder2.activities[0];
      expect(shareHolding2.sharesAt(name, null), 75);

      PersonalTaxPosition taxPosition1 = shareholder1.taxYear(2018);
      taxPosition1.tax;
      expect(taxPosition1.dividendIncome, 12500);  // 25% of first div
      expect(taxPosition1.tax, 14490); // CGT on shares sale

      PersonalTaxPosition taxPosition2 = shareholder2.taxYear(2018);
      taxPosition2.tax;
      expect(taxPosition2.dividendIncome, 75000); // 75% of both divs
      expect(taxPosition2.tax, 11887.50);

      PersonalTaxPosition taxPosition3 = shareholder3.taxYear(2018);
      taxPosition3.tax;
      expect(taxPosition3.dividendIncome, 12500);  // 25% of second div
      expect(taxPosition3.tax, 0);


    });

    test('dividend with a partial transfer', () {
      Company company = new Company()
        .. name = 'company';
      Person shareholder1; // 50%
      Person shareholder2; // 50%
      Person shareholder3; // receives later

      shareholder1 = new Person()
        .. name = "person 1";
      shareholder2 = new Person()
        .. name = 'perons 2';
      shareholder3 = new Person()
        .. name = 'person 3';
      
      String ords = company.ordinaryShares.name.valueAt(null);

      Date before = new Date(1,5,17);
      Date after = new Date(1,10,17);

      ShareHolding holding1 = company.founder(shareholder1, 50);
      ShareHolding holding2 = company.founder(shareholder2, 50);

      Date date = new Date(1,8,17);
      new ShareTransaction(holding1)
      ..numberOfShares = 25
        .. date = date
        ..seller = holding1.owner(date)
        ..buyer = shareholder3
        ..consideration = 0
      ..go();


      ShareHolding holding3 = shareholder3.activities[0];

      expect(holding1.sharesAt(ords, before), 50);
      expect(holding2.sharesAt(ords, before), 50);

      expect(holding1.sharesAt(ords, after), 25);
      expect(holding2.sharesAt(ords, after), 50);
      expect(holding3.sharesAt(ords, after), 25);
      
      company.payDividend(new Date(1,6,17), 100000);
      company.payDividend(new Date(1,9,17), 100000);

      expect(company.ordinaryShares.dividends[0].amount, 100000);

      PersonalTaxPosition taxPosition1 = shareholder1.taxYear(2018);
      taxPosition1.tax;
      expect(taxPosition1.dividendIncome, 75000);  //50% of £100k plus 25% of £100k
      expect(taxPosition1.tax, 11887.50);

      PersonalTaxPosition taxPosition2 = shareholder2.taxYear(2018);
      taxPosition2.tax;
      expect(taxPosition2.dividendIncome, 100000); //50% of £100k plus 50% of £100k
      expect(taxPosition2.tax, 20012.50);

      PersonalTaxPosition taxPosition3 = shareholder3.taxYear(2018);
      taxPosition3.tax;
      expect(taxPosition3.dividendIncome, 25000);  //25% of £100k
      expect(taxPosition3.tax, 637.50);

    });





  });


}

void stampDuty(){

  group('Stamp Duty ', (){

    test('SDLT residential', () {

      PropertyTransaction transaction = new PropertyTransaction()
      ..asset = new ResidentialProperty(new Person())
        ..consideration = 100000
        ..go();

        expect(transaction.duty, 0);

        transaction.consideration = 200000;
        expect(transaction.duty, 1500);

      transaction.consideration = 300000;
      expect(transaction.duty, 5000);

      transaction.consideration = 400000;
      expect(transaction.duty, 10000);

      transaction.consideration = 700000;
      expect(transaction.duty, 25000);

      transaction.consideration = 1000000;
      expect(transaction.duty, 43750);

      transaction.consideration = 2000000;
      expect(transaction.duty, 153750);

      transaction.consideration = 10000000;
      expect(transaction.duty, 1113750);

    });

    test('SDLT non residential', () {

      PropertyTransaction transaction = new PropertyTransaction()
      ..asset = new Property(new Person())
        ..consideration = 100000
        ..go();

      expect(transaction.duty, 0);

      transaction.consideration = 200000;
      expect(transaction.duty, 1000);

      transaction.consideration = 300000;
      expect(transaction.duty, 4500);

      transaction.consideration = 400000;
      expect(transaction.duty, 9500);

      transaction.consideration = 700000;
      expect(transaction.duty, 24500);

      transaction.consideration = 1000000;
      expect(transaction.duty, 39500);

      transaction.consideration = 2000000;
      expect(transaction.duty, 89500);

      transaction.consideration = 10000000;
      expect(transaction.duty, 489500);

    });

    test('SDLT shares', () {

      ShareTransaction transaction = new ShareTransaction()
      ..asset = new ChargeableAsset(new Person())
        ..consideration = 900
        ..go();

      expect(transaction.duty, 0);

      transaction.consideration = 2000;
      expect(transaction.duty, 10);

      transaction.consideration = 300000;
      expect(transaction.duty, 1500);

     transaction.consideration = 1000000;
      expect(transaction.duty, 5000);

      transaction.consideration = 2000000;
      expect(transaction.duty, 10000);

      transaction.consideration = 10000000;
      expect(transaction.duty, 50000);

    });

  });


}