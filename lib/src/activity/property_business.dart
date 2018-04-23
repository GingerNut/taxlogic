
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

    cessation = transaction.date + (-1);

    PropertyBusiness newbusiness = new PropertyBusiness(transaction.seller)
    ..commencement = transaction.date
    ..name = name;

    properties.forEach((property){
      property.sell(property.owner(transaction.date), transaction.date, 0);

      Property newProp;

      if(property is ResidentialProperty) newProp = new ResidentialProperty(transaction.buyer);
      else newProp = new Property(transaction.buyer)
      ..changeRent(property.getRent(transaction.date), transaction.date)
        ..changeInterest(property.getInterest(transaction.date), transaction.date);

      newbusiness.properties.add(newProp);

    });

    transaction.seller.activities.add(newbusiness);
  }

  @override
  PropertyIncome getNewIncome(TaxPosition taxPosition) => new PropertyIncome(this, taxPosition);


}