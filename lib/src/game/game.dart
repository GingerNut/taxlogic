import 'package:taxlogic/src/game/position/position.dart';
import 'position/landlord_start.dart';
import '../date.dart';

class Game{
  static const LANDLORD = 1;

  Position position;

  Game(){

  }

  newGame(int gameType, Date date){
    position = startingPosition(gameType, date);


  }

  Position startingPosition(int gameType, Date date){

    Position position;

    switch(gameType){
      case LANDLORD : position = new LandlordStart(this, date);
      break;

      default: position = new Position(this, null, null);
    }

    return position;
  }


}