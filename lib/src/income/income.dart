import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
export 'rental_income.dart';
export 'employment_income.dart';
export 'interest_income.dart';

export 'package:taxlogic/src/accounts/payment.dart';
export 'dividend_income.dart';


class Income{
  Income(this.activity, this.taxPosition){
    taxPosition.income.add(this);
    activity.incomeHistory.add(this);
  }

  final Activity activity;
  final TaxPosition taxPosition;



  bool manualSet = false;
  num manualSetIncome = 0;
  num _taxDeducted = 0;

  num get income {
    if(manualSet) return manualSetIncome;

    num income = automaticIncome(taxPosition.period);

    bool scotland = false;

    if(activity.owner is Person) scotland = (activity.owner as Person).scotland;

    if(activity.taxDeductedAtSource) _taxDeducted = TaxData.BasicRate(taxPosition.period.end.year, scotland) * income;

    return income;
  }

  num automaticIncome(Period period) => activity.annualIncome.overallAmount(taxPosition.period);

  set income(num amount){
    manualSet = true;
    manualSetIncome = amount;
  }

  num get taxDeducted => _taxDeducted;

  num get foreignTax => 0;

  num get taxCredit => 0;

}