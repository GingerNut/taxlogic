import 'package:taxlogic/src/game/position/position.dart';
import 'position/scenario/scenario.dart';
import 'move/move.dart';

export 'position/position.dart';
export 'move/move.dart';

class Game{
  Game(){
    newGame(null);
  }

  Scenario scenario;
  Position position;
  List<Position> history = new List();

  newGame(Scenario scenario){

    if(scenario == null) scenario = new Blank();

    position = new Position(this, null, null);

    this.scenario = scenario;
    scenario.setup(this);
  }

  makeMove(Move move){

    String test = move.check(position);

    if(test == 'OK'){
      history.add(position);
      position = new Position(this, position, move);
      position.move.go(position);
    } else throw 'move abandoned because ' + test;
  }



}