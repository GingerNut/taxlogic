import '../entity.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/company/dividend.dart';
import 'package:taxlogic/src/entities/company/share_register.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/tax_position/company/company_tax_position.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_end.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';

class Company extends Entity{
  Company(List<ShareHolding> shareholders){
    type = Entity.COMPANY;
    shareRegister = new ShareRegister(this, shareholders);
  }

  Company.unknown(){
    type = Entity.COMPANY;
    List<ShareHolding> shareholders = new List();
    shareholders.add(new ShareHolding(this, new Unknown(), 1));
    shareRegister = new ShareRegister(this, shareholders);
  }

  Company.whollyOwned(Entity entity){
    type = Entity.COMPANY;
    List<ShareHolding> shareholders = new List();
    shareholders.add(new ShareHolding(this, entity, 1));
    shareRegister = new ShareRegister(this, shareholders);
  }

  PeriodEnd defaultPeriod = new PeriodEnd(31,3);
  ShareRegister shareRegister;
  List<Dividend> dividends = new List();

  payDividend(Date date, num amount) => dividends.add(new Dividend(date, shareRegister.getShareholdingsAt(date), amount));

  getDividend(Period period, Entity entity){
    num dividend = 0;

    dividends.forEach((div){
      if(period.includes(div.date)){


      }
    });

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
}



