import '../../entities/entity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import '../game.dart';

class Position{
    final Position lastPosition;
    final Move move;
    final Game game;

    Entity focussedEntity;
    List<Entity> entities = new List();

    Position(this.game, this.lastPosition, this.move){

    }



    addEntity(Entity entity) => entities.add(entity);

    makeFocussed(Entity entity) => focussedEntity = entity;

    num TaxPayable(int taxyear){



    }

}