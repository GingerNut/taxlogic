
import 'package:taxlogic/src/accounts/payment.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../../game.dart';

class EndEmployment extends Move{

  EndEmployment(this.personId, this.identifier, this.cessationDate, this.termination);

  String personId;
  String identifier;
  Date cessationDate;
  num termination;

  doMove(Position position) {

    Person person = position.getEntityByName(personId);

    Employment employment = person.getActivityByName(identifier);

    if(employment == null) return 'employment not found';

    employment.cessation = cessationDate;
    employment.endIncome(cessationDate);
    employment.termination = new Payment(cessationDate, termination);

  }

  String checkMove(Position position) {
    Person person = position.getEntityByName(personId);
    if(person == null) return 'person not found';

    Employment employment = person.getActivityByName(identifier);
    if(employment == null) return 'employment not found';

    if(employment.cessation != null && employment.cessation < cessationDate) return 'employment already ceased';

    return 'OK';
  }
}