import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';


class EmploymentIncome extends Income{
  EmploymentIncome(this.employment, TaxPosition taxPosition) : super(employment, taxPosition);

  Employment employment;

  num carBenefit(){
    num benefit = 0;

    employment.companyCars.forEach((car){
      benefit += car.benefit(taxPosition);
    });
    return benefit;
  }


  num automaticIncome(Period period) {

    num income = activity.annualIncome.overallAmount(period);

    if (employment.termination != null && period.includes(employment.termination.date)) {
      income += employment.termination.amount;
    }

    income += carBenefit();

    return income;
  }

}