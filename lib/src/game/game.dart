import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/game/position/scenario/landlord_start.dart';

import '../date.dart';
import 'position/scenario/scenario.dart';
import 'move/move.dart';

class Game{
  Scenario scenario;
  Position position;
  List<Position> history = new List();

  newGame(Scenario scenario){
    this.scenario = scenario;
    scenario.setup(this);
  }

  makeMove(Move move){
    history.add(position);
    position = new Position(this, position, move);
    position.move.doMove(position);
  }




}