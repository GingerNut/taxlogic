
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

abstract class TaxPosition{
  TaxPosition(this.entity, this.period);

  Entity entity;
  Period period;
  TaxPosition previousTaxPosition;

  CapitalGains capitalGainsTaxPosition;
  Taxation incomeTaxPosition;

  List<ChargeableAsset> disposals = new List();

  num propertyIncome = 0;
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
    tradingIncome = 0;

    entity.assets.forEach((activity){
      if(activity is PropertyBusiness){
        (activity as PropertyBusiness).accounts.forEach((account){
          propertyIncome += (account as IncomeAndExpenditureProperty).profit;
          adjustPropertyProfit(account);
        });

      }

    });

  }

  adjustPropertyProfit(IncomeAndExpenditureProperty accounts);

}