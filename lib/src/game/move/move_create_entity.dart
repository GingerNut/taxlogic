
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/game/position/position.dart';
import '../../entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';


class CreateEntity extends Move{
  CreateEntity(this.date, this.name, this.type): super(Move.CREATE_ENTITY);

  int type;
  Date date;
  String name;
  Entity entity;


  @override
  doMove(Position position) {

    entity = Entity.get(type)
      ..name = name
    ..birth = date;

    position.addEntity(entity);
    if(position.focussedEntity == null) position.focussedEntity = entity;
    }
  }
