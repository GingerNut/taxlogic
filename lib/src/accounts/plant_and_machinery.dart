import '../assets/asset.dart';
import 'capital_allowances.dart';
import '../entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/assets/activity.dart';
import 'package:taxlogic/src/assets/value.dart';

class PlantAndMachinery extends Asset with CapitalAllowances{

  PlantAndMachinery(Entity entity) : super(entity);






  @override
  transferToActivity(Activity activity, Date date, Value value) {
    // TODO: implement transferToActivity
  }
}