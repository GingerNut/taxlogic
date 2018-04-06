
import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/activity/property_business.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';



class CompanyTaxPosition extends TaxPosition{
  CompanyTaxPosition(this.company) : super (company){

    trade = new Income(company.trade, period);
    dividend = new Income(company.investment, period);
    propertyIncome = new PropertyIncome(company.propertyBusiness, period);
    other = new Income(company.other, period);

    income.add(trade);
    income.add(dividend);
    income.add(propertyIncome);
    income.add(other);

  }

  final Company company;

  Income trade;
  Income dividend;
  PropertyIncome propertyIncome;
  Income other;



  // TODO: implement tax
  @override
  num get tax => null;

  @override
  refreshIncome() {
    entity.activities.forEach((activity){

      if(activity is PropertyBusiness){

        IncomeAndExpenditureProperty accounts;

        activity.accounts.forEach((ap) {

          if(period.includes(ap.period.end)) accounts = ap;
        });

        if(accounts != null) propertyIncome.accounts = accounts;

      }


    });
  }
}