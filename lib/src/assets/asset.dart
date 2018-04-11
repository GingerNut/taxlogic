import '../entities/entity.dart';
import 'acquisition/acquisition.dart';
import 'disposal/disposal.dart';

export 'vehicle.dart';
export 'property.dart';

abstract class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;

  Acquisition acquisition = new Purchase(null, 0);
  Disposal disposal = new Sale(null, 0);


  Asset transferTo(Entity transferee, Disposal disposal);

}