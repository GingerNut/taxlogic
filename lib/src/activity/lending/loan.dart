import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/activity/lending/lending_activity.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/history/num_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class Loan extends Asset{
  Loan(Entity lenderEntity) : super(lenderEntity){
    lendingActivity = new LendingActivity(this, lenderEntity);

  }

  LendingActivity lendingActivity;
  Activity borrower;

  NumHistory principle = new NumHistory();
  NumHistory interest = new NumHistory();

  set taxDeductedAtSource (bool setting)=> lendingActivity.taxDeductedAtSource = setting;



}

