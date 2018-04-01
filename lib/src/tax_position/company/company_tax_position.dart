
import '../../taxlogic.dart';
import '../taxation/corporation_tax.dart';
import '../taxation/company_capital_gains.dart';



class CompanyTaxPosition extends TaxPosition{

  num income = 0;

  CompanyTaxPosition(Entity entity) : super (entity){
    incomeTaxPosition = new CorporationTax(this);
    capitalGainsTaxPosition = new CompanyCapitalGainsPosition(this);

  }




  @override
  adjustPropertyProfit(IncomeAndExpenditureProperty accounts) {

  }
}