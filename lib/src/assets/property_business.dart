import 'property.dart';
import 'activity.dart';
import '../entities/entity.dart';


class PropertyBusiness extends Activity{

  List<Property> properties = new List();

  PropertyBusiness(Entity entity): super(entity);

  
}