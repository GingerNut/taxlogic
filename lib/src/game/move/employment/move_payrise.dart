import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../../game.dart';

class PaychangeEmployment extends Move{

  PaychangeEmployment(this.identifier, this.date, this.amount);

  String identifier;
  Date date;
  num amount;

  doMove(Position position) {

    Employment employment = position.getActivityByName(identifier);
    employment.changeIncome(date, amount);

  }
}