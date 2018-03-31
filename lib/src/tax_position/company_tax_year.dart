import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'tax_position.dart';
import '../period_collection.dart';
import '../date.dart';
import '../period.dart';

class CompanyTaxYear extends TaxPosition{
  PeriodCollection accountingPeriods;

  CompanyTaxYear(Entity entity, int taxYear) : super(entity){
    Date start = new Date(1,4,taxYear -1);
    if(start < entity.birth) start = entity.birth;

    Date end = new Date(31,3,taxYear);

    period = new Period(start,end);
    accountingPeriods = new PeriodCollection(period, entity);

  }








  @override
  adjustPropertyProfit(IncomeAndExpenditureProperty accounts) {
    // TODO: implement adjustPropertyProfit
  }
}