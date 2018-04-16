import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';

class Savings extends Activity{
  Savings(Entity entity) : super(entity);




  @override
  Income getNewIncome(TaxPosition taxPosition) => new Income(this, taxPosition);


}