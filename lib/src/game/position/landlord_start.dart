import 'package:taxlogic/src/game/game.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'position.dart';
import '../../entities/person.dart';
import '../../assets/property_business.dart';
import '../../date.dart';
import '../../assets/residential_property.dart';


class LandlordStart extends Position{
  LandlordStart(Game game, Date start, ) : super(game, null, null);

  PropertyBusiness business;


  @override
  setUp() {
    entity = new Person();
    business = new PropertyBusiness(entity);

    ResidentialProperty property = new ResidentialProperty(entity);
    business.properties.add(property);

    property.annualRent = 20000;
    property.annualInterest = 20000;
  }


}