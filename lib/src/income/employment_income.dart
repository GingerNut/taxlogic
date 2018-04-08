import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';


class EmploymentIncome extends Income{
  EmploymentIncome(this.employment, TaxPosition taxPosition) : super(employment, taxPosition);

  Employment employment;

  num get income {
    if(manualSet) return manualSetIncome;

    num income = activity.annualIncome.overallAmount(taxPosition.period);

    if (employment.termination != null && taxPosition.period.includes(employment.termination.date)) {
      income += employment.termination.amount;
    }

    return income;
  }

}