
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/game/position/position.dart';
import '../../entities/entity.dart';


class CreateEntity extends Move{
  CreateEntity(this.name, int type, Position position): super(Move.CREATE_ENTITY, position);

  String name;
  Entity entity;

  @override
  setUp() {
     entity = Entity.get(type)
     ..name = name;
    }

  @override
  doMove(Position position) {
    position.addEntity(entity);
    }
  }
