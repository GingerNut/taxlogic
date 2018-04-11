import 'package:taxlogic/src/assets/property.dart';

import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/value/value.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../entities/entity.dart';
import '../assets/residential_property.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';

class PropertyBusiness extends Activity{

  List<Property> properties = new List();

  PropertyBusiness(Entity entity): super(entity);
  
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
      property.disposal.date  = date + (-1);

      Property newProp;

      if(property is ResidentialProperty) newProp = new ResidentialProperty(transferee);
      else newProp = new Property(transferee);

      newProp
        ..setRent(property.getRent(date), date)
        ..setInterst(property.getInterest(date), date);

      newbusiness.properties.add(newProp);

    });

    transferee.activities.add(newbusiness);
  }

  PropertyIncome income(TaxPosition taxPosition) {
    PropertyIncome _income = new PropertyIncome(this, taxPosition);

    properties.forEach((e){
      _income.income += e.rent(taxPosition.period);
    });
    return _income;
  }

  @override
  Income getNewIncome(TaxPosition taxPosition) => new PropertyIncome(this, taxPosition);

}