import 'package:taxlogic/src/accounts/accounting_period.dart';
import 'package:taxlogic/src/accounts/income_and_expenditure.dart';
import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';




class PropertyIncome extends Income{
  PropertyIncome(this.business, TaxPosition taxPosition) : super(business, taxPosition);

  PropertyBusiness business;

  IncomeAndExpenditureProperty accounts;

  get income{

    business.accounts.forEach((ap){

      if(taxPosition.period.includes(ap.period.end)) accounts = ap;

    });

    if(accounts == null){  // create accounts from sources

      accounts = new IncomeAndExpenditureProperty(taxPosition.period, business.entity);

      business.properties.forEach((property){
        accounts.add(new IncomeAccount(accounts.period.end, 'rent', property.rent(taxPosition.period)));
        accounts.add(new Interest(accounts.period.end, 'interest', property.interest(taxPosition.period)));
        accounts.add(new ExpenditureAccount(accounts.period.end, 'expenses', property.generalExpenses(taxPosition.period)));
      });

    }

    return accounts.profit;
  }

  get taxCredit{

    if(activity == null) return 0;

    if(accounts == null) {
        return 0;

    } else {
      bool scotland = false;
      if(activity.entity is Person) scotland = (activity.entity as Person).scotland;

      return accounts.interestRestriction * TaxData.BasicRate(taxPosition.period.end.year, scotland);
    }
  }




}