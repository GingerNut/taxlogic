
import '../../taxlogic.dart';
import '../taxation/corporation_tax.dart';
import '../taxation/company_capital_gains.dart';

class CompanyTaxPosition extends TaxPosition{
  static const String jsonTagCode = "code";
  static const String jsonTagYear = "year";
  static const String jsonTagEarnings = "earnings";
  static const String jsonTagTrade = "trade";
  static const String jsonTagDividend = "dividend";
  static const String jsonTagSavings = "savings";


  num income = 0;

  CompanyTaxPosition(Entity entity, Period period) : super (entity, period){
    incomeTaxPosition = new CorporationTax(this);
    capitalGainsTaxPosition = new CompanyCapitalGainsPosition(this);

  }




}