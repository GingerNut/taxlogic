
import 'package:taxlogic/src/assets/property/property.dart';

import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../entities/entity.dart';
import 'package:taxlogic/src/assets/property/residential_property.dart';
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
  transfer(Transaction transaction) {

    cessation = disposal.date + (-1);

    PropertyBusiness newbusiness = new PropertyBusiness(transaction.seller)
    ..commencement = disposal.date
    ..name = name;

    properties.forEach((property){
      property.disposal.date  = disposal.date + (-1);

      Property newProp;

      if(property is ResidentialProperty) newProp = new ResidentialProperty(transaction.seller);
      else newProp = new Property(transaction.seller);

      newProp
        ..changeRent(property.getRent(disposal.date), disposal.date)
        ..changeInterest(property.getInterest(disposal.date), disposal.date);

      newbusiness.properties.add(newProp);

    });

    transaction.seller.activities.add(newbusiness);
  }

  @override
  PropertyIncome getNewIncome(TaxPosition taxPosition) => new PropertyIncome(this, taxPosition);


}