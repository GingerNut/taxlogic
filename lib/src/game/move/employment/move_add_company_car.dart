import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../../game.dart';

class EmploymentCompanyCar extends Move{

  EmploymentCompanyCar(this.personId, this.employmentId, this.carId, this.madeAvailable, this.firstReg, this.listPrice, this.CO2);

  String personId;
  String employmentId;
  String carId;

  Date madeAvailable;
  Date firstReg;
  num listPrice;
  num CO2;

  go(Position position) {

    Person person = position.getEntityByName(personId);
    Employment employment = person.getActivityByName(employmentId);

    CompanyCar car = new CompanyCar()
    ..CO2 = CO2
    ..registered = firstReg
    ..madeAvailable = madeAvailable
    ..listPrice = listPrice;

    employment.companyCars.add(car);

  }

  String check(Position position) {
    Person person = position.getEntityByName(personId);
    if(person == null) return 'person not found';
    if(person.type != Entity.INDIVIDUAL) return 'only individuals can have company cars';

    Employment employment = person.getActivityByName(employmentId);
    if(employment == null) return 'employment not found';

    return 'OK';
  }
}