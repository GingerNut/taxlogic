import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/value.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/date.dart';


class Employment extends Activity{
  Employment(this.employee) : super(employee);

  Person employee;
  Payment termination;



  @override
  transferToEntity(Date date, Entity transferee, Value value) {
    // TODO: implement transferToEntity
  }




  @override
  Income getNewIncome(TaxPosition taxPosition) => new EmploymentIncome(this, taxPosition);
}
