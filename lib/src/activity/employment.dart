import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/value.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';


class Employment extends Activity{
  Employment(Person entity) : super(entity);



  @override
  transferToEntity(Date date, Entity transferee, Value value) {
    // TODO: implement transferToEntity
  }
}