
import 'package:taxlogic/src/accounts/payment.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../position/position.dart';

class EndEmployment extends Move{

  EndEmployment(this.identifier, this.date, this.termination);

  String identifier;
  int type;
  Date date;
  num termination;

  @override
  doMove(Position position) {

    Employment employment = position.getActivityByName(identifier);

    employment.cessation = date;
    employment.endIncome(date);
    employment.termination = new Payment(date, termination);

  }
}