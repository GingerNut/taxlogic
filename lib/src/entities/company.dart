import 'entity.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/tax_position/company/company_tax_position.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_end.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';

class Company extends Entity{
  Company(){
    type = Entity.COMPANY;

    trade = new Trade(this);
    investment = new ShareHolding(this);
    savings = new Savings(this);
    propertyBusiness = new PropertyBusiness(this);
    other = new Other(this);

  }

  PeriodEnd defaultPeriod = new PeriodEnd(31,3);

  Trade trade;
  ShareHolding investment;
  Savings savings;
  PropertyBusiness propertyBusiness;
  Other other;


  CompanyAccountingPeriod accountingPeriod(Period period){

    Date start = period.start;
    Date end = period.end;

    CompanyTaxPosition lastPos = lastAccountingPeriod();
    CompanyAccountingPeriod newPeriod;

    if(lastPos == null){
      newPeriod = new CompanyAccountingPeriod(this, new Period(start,end));

      taxPeriods.add(newPeriod);

      return newPeriod;

    } else {

      if(lastPos.period.end > period.end) return lastPos;

      if(lastPos.period.end == period.end) return lastPos;

      int overlap = Period.overlap(lastPos.period, period);

      if(overlap > 0 && lastPos.period.end < period.end) {
        start = lastPos.period.end + 1;

        newPeriod = new CompanyAccountingPeriod(this, new Period(start,end));

        taxPeriods.add(newPeriod);
      }

    }

    newPeriod = new CompanyAccountingPeriod(this, new Period(start,end));
    taxPeriods.add(newPeriod);

    return newPeriod;
  }

  CompanyAccountingPeriod lastAccountingPeriod(){
    Date lastAPend;
    CompanyAccountingPeriod lastAP;

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







  @override
  PeriodCollection getTaxPeriods(Period period) {
    // TODO: implement getTaxPeriods
  }

  @override
  CompanyTaxPosition taxYear(int taxYearEnd) {
    // TODO: implement taxYear
  }
}