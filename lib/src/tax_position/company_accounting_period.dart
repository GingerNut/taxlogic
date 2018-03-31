import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'tax_position.dart';
import '../period.dart';


class CompanyAccountingPeriod extends CompanyTaxPosition{
  CompanyAccountingPeriod(Entity entity, Period period) : super(entity) {
    this.period = period;
  }







  @override
  adjustPropertyProfit(IncomeAndExpenditureProperty accounts) {
    // TODO: implement adjustPropertyProfit
  }
}