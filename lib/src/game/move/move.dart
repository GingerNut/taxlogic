
import '../position/position.dart';
import '../../date.dart';
import 'move_start_activity.dart';

abstract class Move{
  static const int RESIDENTIAL_PROPERTY_BUSINESS = 1;

  Position position;

  int type;


  Move(this.type, this.position);


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


}