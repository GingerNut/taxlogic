
import '../entities/entity.dart';
import '../assets/chargeable_assets.dart';
import '../period.dart';
import '../data/tax_data.dart';
import '../taxation/capital_gains.dart';
import '../tax_position/company_tax_position.dart';
import '../taxation/taxation.dart';
import '../accounts/accounting_period.dart';
import '../assets/property_business.dart';
import '../accounts/rental_income_and_expenditure.dart';
import '../accounts/accounts.dart';

export 'company_tax_position.dart';
export 'personal_tax_position.dart';
export 'company_accounting_period.dart';

abstract class TaxPosition{
  static const String jsonTagCode = "code";
  static const String jsonTagYear = "year";
  static const String jsonTagEarnings = "earnings";
  static const String jsonTagTrade = "trade";
  static const String jsonTagDividend = "dividend";
  static const String jsonTagSavings = "savings";


  TaxPosition(this.entity);

  Entity entity;
  Period period;
  TaxPosition previousTaxPosition;

  CapitalGains capitalGainsTaxPosition;
  Taxation incomeTaxPosition;

  List<ChargeableAsset> disposals = new List();

  num propertyIncome = 0;
  num propertyTaxCredit = 0;
  num tradingIncome = 0;

  refreshDisposals() {

    disposals.clear();
    entity.assets.forEach((asset) {
      if(asset is ChargeableAsset && asset.saleDate != null){
        if(period.includes(asset.saleDate)){
          disposals.add(asset);
        }
      }
    });

  }

  refreshIncome(){
    propertyIncome = 0;
    propertyTaxCredit = 0;
    tradingIncome = 0;

    entity.activities.forEach((activity){
      if(activity is PropertyBusiness){
        (activity as PropertyBusiness).accounts.forEach((account){

          if(period.includes(account.period.end)){
          propertyIncome += (account as IncomeAndExpenditureProperty).profit;
          propertyTaxCredit += (account as IncomeAndExpenditureProperty).taxCredit;
          }

        });

      }

    });

  }

  adjustPropertyProfit(IncomeAndExpenditureProperty accounts);

}