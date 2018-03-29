import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/game/position/scenario/landlord_start.dart';
import 'position/blank_position.dart';
import '../date.dart';
import 'position/scenario/scenario.dart';

class Game{
  Scenario scenario;
  Position position;

  Game();

  newGame(Scenario scenario){
    this.scenario = scenario;

    scenario.setup(this);


  }




}