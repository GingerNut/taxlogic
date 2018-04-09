
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/game/position/position.dart';
import '../../../entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';


class CreateCompany extends Move{
  CreateCompany(this.date, this.name);

  int type;
  Date date;
  String name;
  Company company;


  @override
  doMove(Position position) {

    company = Entity.get(Entity.COMPANY)
      ..name = name
    ..birth = date;

    position.addEntity(company);
    if(position.focussedEntity == null) position.focussedEntity = company;
    }


  }
