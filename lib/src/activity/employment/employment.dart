import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/activity/employment/company_car.dart';
import 'package:taxlogic/src/assets/value/value.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/date.dart';

export 'company_car.dart';


class Employment extends Activity{
  Employment(this.employee) : super(employee);

  Entity employer;
  Person employee;
  Payment termination;

  List<CompanyCar> companyCars = new List();




  @override
  transferToEntity(Date date, Entity transferee, Value value) {
    // TODO: implement transferToEntity
  }




  @override
  Income getNewIncome(TaxPosition taxPosition) => new EmploymentIncome(this, taxPosition);
}
