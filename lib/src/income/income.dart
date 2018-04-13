import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
export 'rental_income.dart';
export 'employment_income.dart';

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

  num get income {
    if(manualSet) return manualSetIncome;

    else return automaticIncome(taxPosition.period);
  }

  num automaticIncome(Period period) => activity.annualIncome.overallAmount(taxPosition.period);

  set income(num amount){
    manualSet = true;
    manualSetIncome = amount;
  }

  num get taxDeducted => 0;

  num get foreignTax => 0;

  num get taxCredit => 0;

}