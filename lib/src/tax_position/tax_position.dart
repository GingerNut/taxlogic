
import '../entities/entity.dart';
import '../assets/chargeable_assets.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../data/tax_data.dart';
import '../taxation/capital_gains.dart';
import 'package:taxlogic/src/tax_position/company/company_tax_position.dart';
import '../taxation/taxation.dart';
import '../accounts/accounting_period.dart';
import '../assets/property_business.dart';
import '../accounts/rental_income_and_expenditure.dart';
import '../accounts/accounts.dart';
import '../income/income.dart';

export 'package:taxlogic/src/tax_position/company/company_tax_position.dart';
export 'package:taxlogic/src/tax_position/personal/personal_tax_2018.dart';
export 'package:taxlogic/src/tax_position/company/company_accounting_period.dart';

abstract class TaxPosition{
  TaxPosition(this.entity);

  Entity entity;
  Period period;
  TaxPosition previousTaxPosition;

  List<Income> income = new List();
  List<ChargeableAsset> disposals = new List();

  num capitalLossBroughtForward = 0;
  num capitalLossCarriedForward = 0;

  num get tax;

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

}