import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/game/position/scenario/landlord_start.dart';
import 'position/blank_position.dart';
import '../date.dart';
import 'position/scenario/scenario.dart';

class Game{
  Scenario scenario;
  Position position;

  Game(){

  }

  newGame(Scenario scenario, Date date){
    this.scenario = scenario;
    position = startingPosition(scenario, date);

    position.setUp();


  }

  Position startingPosition(Scenario scenario, Date date){

    Position position;

    switch(scenario.type){
      case Scenario.LANDLORD : position = new LandlordStart(this, scenario);
      break;

      default: position = new BlankStart(this, scenario.start);
    }

    return position;
  }


}