
import 'package:taxlogic/src/accounts/payment.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../../game.dart';

class EndEmployment extends Move{

  EndEmployment(this.identifier, this.cessationDate, this.termination);

  String identifier;
  Date cessationDate;
  num termination;

  doMove(Position position) {

    Employment employment = position.getActivityByName(identifier);

    employment.cessation = cessationDate;
    employment.endIncome(cessationDate);
    employment.termination = new Payment(cessationDate, termination);

  }
}