
import 'package:taxlogic/src/game/move/move.dart';
import '../../date.dart';
import '../../assets/property.dart';
import '../../assets/residential_property.dart';
import '../position/position.dart';

class StartActivity extends Move{

  static const int PROPERTY_BUSINESS = 1;

  int type;
  bool residential;
  Date start;
  num cost;
  num finance;
  num projectedIncome;
  num projectedFinanceCost;

  StartActivity(Position position): super(position);


  setUp(){

    switch(type){

      case PROPERTY_BUSINESS: setUpPropertyBusiness();
        break;


    }

  }





  setUpPropertyBusiness(){

    Property property;

    if(residential) property = new ResidentialProperty(position.entity);
    else property = new Property(position.entity);

    property.setRent(projectedIncome, start);
    property.setInterst(projectedFinanceCost, start);


  }


}