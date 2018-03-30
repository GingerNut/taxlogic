
import 'package:taxlogic/src/game/move/move.dart';
import '../../date.dart';
import '../../assets/property.dart';
import '../../assets/residential_property.dart';
import '../position/position.dart';

class StartActivity extends Move{




  StartActivity(int type, Position position): super(type, position);








  setUpResidentialPropertyBusiness(){
    Property property;

    property = new ResidentialProperty(originalPosition.focussedEntity);

    property.setRent(originalPosition.game.scenario.projectedIncome, originalPosition.game.scenario.start);
    property.setInterst(originalPosition.game.scenario.projectedFinanceCost, originalPosition.game.scenario.start);


  }


  @override
  setUp() {
    // TODO: implement setUp
  }

  @override
  doMove(Position newPosition) {
    // TODO: implement doMove
  }
}