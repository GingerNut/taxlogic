import '../../entities/entity.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import '../game.dart';

class Position{
    final Position lastPosition;
    final Move move;
    final Game game;

    Entity focussedEntity;
    List<Entity> entities = new List();

    Position(this.game, this.lastPosition, this.move){
        if(lastPosition != null) copyStaticData();
    }


    copyStaticData(){
        lastPosition.entities.forEach((e){
                addEntity(e);
            });

            focussedEntity = lastPosition.focussedEntity;
    }

    addEntity(Entity entity) => entities.add(entity);

    makeFocussed(Entity entity) => focussedEntity = entity;

   num TaxPayable(int taxyear){



    }

    Entity getEntityByName(String identifier){
     Entity named ;

     entities.forEach((e){
       if(e.name == identifier) named = e;
     });

     return named;
    }

    Activity getActivityByName(String identifier){
      Activity named;

     entities.forEach((ent){
       ent.activities.forEach((e){
         if(e.name == identifier) named = e;
       });

     });

      return named;
    }

    printEntities(){
        entities.forEach((e){
            print('${e.name}');
        });
    }

}