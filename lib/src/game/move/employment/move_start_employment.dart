
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../../position/position.dart';

class StartEmployment extends Move{

  StartEmployment(this.personId, this.employmentId, this.date, this.income);

  String employmentId;
  String personId;
  int type;
  Date date;
  num income;

  @override
  doMove(Position position) {

    Person person = position.getEntityByName(personId);
    Employment employment = new Employment(person);
    employment.name = employmentId;
    employment.commencement = date;
    employment.setIncome(income);
  }
}