
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/game/position/position.dart';
import '../../../entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';


class CreateIndividual extends Move{
  CreateIndividual(this.date, this.name);

  int type;
  Date date;
  String name;
  Person person;


  @override
  doMove(Position position) {

    person = Entity.get(Entity.INDIVIDUAL)
      ..name = name
    ..birth = date;

    position.addEntity(person);
    if(position.focussedEntity == null) position.focussedEntity = person;
    }


    @override
  String checkMove(Position test) {
    return 'OK';
  }
}
