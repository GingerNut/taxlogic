import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'tax_position.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/period.dart';


// this shows tax payable for a year to 31 March to compare with tax years
// income is shared between accounting periods
// gains are taxed on the basis of the disposal date
// this is therefore a hyrbid approach to allow game to be based on tax years
// this should not be used for actual accounitng perids = that is covered separately

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