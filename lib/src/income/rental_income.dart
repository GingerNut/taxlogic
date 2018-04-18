import 'package:taxlogic/src/accounts/accounting_period.dart';
import 'package:taxlogic/src/accounts/income_and_expenditure.dart';
import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';




class PropertyIncome extends Income{
  PropertyIncome(this.business, TaxPosition taxPosition) : super(business, taxPosition);

  PropertyBusiness business;

  IncomeAndExpenditureProperty accounts;

  num automaticIncome (Period period){

    business.accounts.forEach((ap){

      if(period.includes(ap.period.end)) accounts = ap;

    });

    if(accounts == null){  // create accounts from sources

      accounts = new IncomeAndExpenditureProperty(period, business.owner);

      business.properties.forEach((property){

        // adjust for period of ownership fo the property

        Date start = property.acquisition.date == null ? period.start : property.acquisition.date;
        if(start < period.start) start = period.start;

        Date end = property.disposal.date == null ? period.end : property.disposal.date;
        if(end > period.start) end = period.end;
        Period common = new Period (start, end);

        accounts.add(new IncomeAccount(accounts.period.end, 'rent', property.rent(common)));
        accounts.add(new Interest(accounts.period.end, 'interest', property.interest(common)));
        accounts.add(new ExpenditureAccount(accounts.period.end, 'expenses', property.generalExpenses(common)));

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
      if(activity.owner is Person) scotland = (activity.owner as Person).scotland;

      return accounts.interestRestriction * TaxData.BasicRate(taxPosition.period.end.year, scotland);
    }
  }




}