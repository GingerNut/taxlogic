import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/game/position/scenario/landlord_start.dart';

import '../date.dart';
import 'position/scenario/scenario.dart';
import 'move/move.dart';

class Game{
  Scenario scenario;
  Position position;
  List<Position> history = new List();

  Game();

  newGame(Scenario scenario){
    this.scenario = scenario;

    scenario.setup(this);


  }

  makeMove(Move move){
    move.setUp();
    history.add(position);
    position = new Position(this, position, move);
  }




}