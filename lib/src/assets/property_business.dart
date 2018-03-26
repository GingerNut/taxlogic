import 'property.dart';
import 'activity.dart';
import '../period.dart';
import '../entities/entity.dart';
import '../assets/residential_property.dart';


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

  
}