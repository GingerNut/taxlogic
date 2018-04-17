import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/activity/lending/loan.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';




class LendingActivity extends Activity{
  LendingActivity(this.loan ,Entity entity) : super(entity);

  Loan loan;





  @override
  InterestIncome getNewIncome(TaxPosition taxPosition) => new InterestIncome(this, taxPosition);


}