
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../position/position.dart';

class StartActivity extends Move{

  StartActivity(this.type, this.date, this.income): super(Move.START_ACTIVITY);

  int type;
  Date date;
  num income;

  @override
  doMove(Position position) {
    Activity activity;

    switch(type){
      case Activity.EMPLOYMENT: activity = new Employment(position.focussedEntity as Person);
        break;

      case Activity.TRADE: activity = new Trade(position.focussedEntity);
        break;

    }
    activity.commencement = date;

    activity.setIncome(income);

  }
}