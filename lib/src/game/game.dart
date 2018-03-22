import 'package:taxlogic/src/game/position/position.dart';


class Game{

  Position position;

  Game(){
    newGame();

  }

  newGame(){
    Position position = new Position(this, null, null);


  }


}