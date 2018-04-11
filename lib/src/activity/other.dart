import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
import 'package:taxlogic/src/assets/value/value.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';

class Other extends Activity{
  Other(Entity entity) : super(entity);



  @override
  transferToEntity(Date date, Entity transferee, Value value) {
    // TODO: implement transferToEntity
  }


  @override
  Income getNewIncome(TaxPosition taxPosition) => new Income(this, taxPosition);

  @override
  transferTo(Entity entity, Disposal disposal) {
    // TODO: implement transferTo
  }
}