import 'package:taxlogic/src/utilities/date.dart';
import '../../game.dart';

export 'blank.dart';

abstract class Scenario {
  static const RESIDENTIAL_LANDLORD = 1;
  static const BLANK = 0;


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