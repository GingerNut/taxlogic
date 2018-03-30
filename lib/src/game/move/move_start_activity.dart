
import 'package:taxlogic/src/game/move/move.dart';
import '../../date.dart';
import '../../assets/property.dart';
import '../../assets/residential_property.dart';
import '../position/position.dart';

class StartActivity extends Move{




  StartActivity(int type, Position position): super(type, position);








  setUpResidentialPropertyBusiness(){
    Property property;

    property = new ResidentialProperty(position.focussedEntity);

    property.setRent(position.game.scenario.projectedIncome, position.game.scenario.start);
    property.setInterst(position.game.scenario.projectedFinanceCost, position.game.scenario.start);


  }


  @override
  setUp() {
    // TODO: implement setUp
  }
}