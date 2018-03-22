import 'package:taxlogic/src/game/game.dart';
import 'package:taxlogic/src/game/move/move.dart';
import 'position.dart';
import '../../entities/person.dart';
import '../../assets/property_business.dart';
import '../../date.dart';


class LandlordStart extends Position{
  LandlordStart(Game game, Date start) : super(game, null, null){

    entity = new Person();

    PropertyBusiness business = new PropertyBusiness(entity);




  }




}