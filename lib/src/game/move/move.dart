
import '../position/position.dart';
import '../../date.dart';
import 'move_start_activity.dart';
export 'move_start_activity.dart';
import 'move_create_entity.dart';
export 'move_create_entity.dart';

abstract class Move{
  static const int RESIDENTIAL_PROPERTY_BUSINESS = 1;
  static const int CREATE_ENTITY = 2;

  Position originalPosition;

  int type;


  Move(this.type, this.originalPosition);


  static Move get (int type, Position position){

    Move move;

    switch(type){

      case RESIDENTIAL_PROPERTY_BUSINESS: move = new StartActivity(type, position);
      break;


    }

    move.setUp();

    return move;
  }



  setUp();

  doMove(Position newPosition);

}