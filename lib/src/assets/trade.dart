import 'package:taxlogic/src/entities/person.dart';
import '../accounts/plant_and_machinery.dart';
import '../accounts/income_and_expenditure.dart';
import '../entities/entity.dart';
import '../accounts/trade_accounts.dart';
import 'activity.dart';
import '../date.dart';
import 'value.dart';

class Trade extends Activity{


  Trade(Entity entity) : super(entity);





  // TODO: implement duplicate
  @override
  Activity transferToEntity(Date date, Entity transferee, Value value)  => null;

  @override
  transferToActivity(Activity activity, Date date, Value value) {
    // TODO: implement transferToActivity
  }
}