import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';




class PropertyIncome extends Income{
  PropertyIncome(Activity activity, TaxPosition taxPosition) : super(activity, taxPosition);

  IncomeAndExpenditureProperty accounts;

  get income{
    if(activity.accounts.length == 0) return 0;

    activity.accounts.forEach((ap){
      if(taxPosition.period.includes(ap.period.end)) accounts = ap;
    });

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