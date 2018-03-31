
import '../../taxlogic.dart';
import '../taxation/corporation_tax.dart';
import '../taxation/company_capital_gains.dart';

class CompanyTaxPosition extends TaxPosition{

  num income = 0;
  PeriodCollection accountingPeriods;

  CompanyTaxPosition(Entity entity, Period period) : super (entity, period){
    incomeTaxPosition = new CorporationTax(this);
    capitalGainsTaxPosition = new CompanyCapitalGainsPosition(this);

  }




  @override
  adjustPropertyProfit(IncomeAndExpenditureProperty accounts) {

  }
}