import '../entity.dart';
import 'package:taxlogic/src/activity/activity.dart';

import 'package:taxlogic/src/entities/company/share_capital.dart';

import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/tax_position/company/company_tax_position.dart';
import 'package:taxlogic/src/utilities/period.dart';

import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export'share_capital.dart';

class Company extends Entity{
  Company(){
    type = Entity.COMPANY;
    ShareCapital ordinary = new ShareCapital('ordinary');
    capital.add(ordinary);
  }

  PeriodEnd defaultPeriod = new PeriodEnd(31,3);
  List<ShareCapital> capital = new List();

  ShareCapital shareCapital(String name, Date date){
    ShareCapital thisShareCap;

    capital.forEach((cap){
      if(cap.name(date) == name) thisShareCap = cap;
    });

    return thisShareCap;
  }

  founder(Entity entity, int shares, Date date) {
    ShareCapital ordinary = shareCapital('ordinary', null);

    ordinary.issue(entity, shares, date);
  }

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

  ShareHolding transferShares(Date date, Entity entity, ShareHolding shareHolding) => shareRegister.transferShares(date, entity, shareHolding);


}



