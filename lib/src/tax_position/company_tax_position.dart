
import '../../taxlogic.dart';
import '../taxation/corporation_tax.dart';
import '../taxation/company_capital_gains.dart';


// this shows tax payable for a year to 31 March to compare with tax years
// income is shared between accounting periods
// gains are taxed on the basis of the disposal date
// this is therefore a hyrbid approach to allow game to be based on tax years
// this should not be used for actual accounitng perids = that is covered separately

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