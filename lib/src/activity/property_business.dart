import 'package:taxlogic/src/assets/property.dart';

import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/value.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../entities/entity.dart';
import '../assets/residential_property.dart';
import 'package:taxlogic/src/utilities/date.dart';


class PropertyBusiness extends Activity{

  List<Property> properties = new List();

  PropertyBusiness(Entity entity): super(entity);
  
  num income (Period period){
    num _income = 0;
    properties.forEach((e){
      _income += e.rent(period);
    });
    return _income;
  }
  
  bool get residential{
    bool _residential = false;
    
    properties.forEach((e){
      if(e is ResidentialProperty) _residential = true;
    });
    
    return _residential;
  }
  
  num interest (Period period){
    num _interest = 0;
    properties.forEach((e){
      _interest += e.interest(period);
    });
    return _interest;
    }

  
  // TODO: implement duplicate
  @override
  transferToEntity(Date date, Entity transferee, Value value) {

    cessation = date + (-1);

    PropertyBusiness newbusiness = new PropertyBusiness(transferee)
    ..commencement = date
    ..name = name;

    properties.forEach((property){
      property.saleDate  = date + (-1);
      property.proceeds = (value as PropertyPorfolio).getValue(property);

      Property newProp;

      if(property is ResidentialProperty) newProp = new ResidentialProperty(transferee);
      else newProp = new Property(transferee);

      newProp
        ..setRent(property.getRent(date), date)
        ..setInterst(property.getInterest(date), date)
        ..cost = (value as PropertyPorfolio).getValue(this);

      newbusiness.properties.add(newProp);

    });

    transferee.activities.add(newbusiness);
  }



}