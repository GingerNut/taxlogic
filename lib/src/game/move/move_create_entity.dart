
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/game/position/position.dart';
import '../../entities/entity.dart';


class CreateEntity extends Move{
  CreateEntity(this.name, int type, Position position): super(Move.CREATE_ENTITY, position);

  String name;
  Entity entity;


  @override
  doMove(Position position) {
    entity = Entity.get(type)
      ..name = name;

    position.addEntity(entity);
    }
  }
