import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/activity/lending/lending_activity.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class InterestIncome extends Income{
  InterestIncome(this.lendingActivity, TaxPosition taxPosition) : super(lendingActivity, taxPosition);

  LendingActivity lendingActivity;

  num automaticIncome(Period period) {

    num income = lendingActivity.loan.interest.overallAmount(taxPosition.period) * lendingActivity.loan.principle.overallAmount(taxPosition.period);

    return income;
  }

}