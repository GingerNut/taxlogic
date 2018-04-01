import 'package:taxlogic/src/utilities/date.dart';
import '../../game.dart';

abstract class Scenario {
  static const RESIDENTIAL_LANDLORD = 1;
  Game game;
  String name;

  Date start;
  int type;

  num cost;
  num finance;
  num projectedIncome;
  num projectedFinanceCost;


  setup(Game game){
    this.game = game;
  }

}