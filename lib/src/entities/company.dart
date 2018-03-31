import 'entity.dart';
import 'package:taxlogic/src/date.dart';
import '../tax_position/company_tax_position.dart';
import '../period.dart';
import '../period_end.dart';
import 'package:taxlogic/src/period_collection.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';

class Company extends Entity{

  List<CompanyAccountingPeriod> accountingPeriods = new List();

  PeriodEnd defaultPeriod = new PeriodEnd(31,3);

  CompanyTaxPosition nextAccountingPeriod(Date date){

      CompanyTaxPosition lastAP = lastAccountingPeriod();

      Date periodStart;
      Date periodEnd;

      if(lastAP == null){
        periodEnd = new Date(defaultPeriod.day, defaultPeriod.month, date.financialYear);
        periodStart = date;
        if(birth > periodStart) periodStart = birth;

      } else if(lastAP.period.end < date){


      } else {
        periodStart = lastAP.period.end + 1;
        periodEnd = new Date(lastAP.period.end.day, lastAP.period.end.month, lastAP.period.end.year +1 );

      }

      CompanyTaxPosition nextAp = new CompanyTaxPosition(this, new Period(periodStart, periodEnd));

      taxPeriods.add(nextAp);

      return nextAp;

  }

  CompanyTaxPosition lastAccountingPeriod(){
    Date lastAPend;
    CompanyTaxPosition lastAP;

    if(taxPeriods.length>0) {
      lastAPend = taxPeriods[0].period.end;
      lastAP = taxPeriods[0];
    }

    taxPeriods.forEach((ap){
      if(ap.period.end > lastAPend){
        lastAPend = ap.period.end;
        lastAP = ap;
      }


    });

    return lastAP;

  }



  Company(){
    type = Entity.COMPANY;

  }

  @override
  num taxPayble(int taxYearEnd) {
    // TODO: implement TaxPayble
  }

  @override
  PeriodCollection getTaxPeriods(Period period) {
    // TODO: implement getTaxPeriods
  }

  @override
  CompanyTaxPosition taxYear(int taxYearEnd) {
    // TODO: implement taxYear
  }
}