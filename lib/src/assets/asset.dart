import '../entities/entity.dart';
import 'acquisition/acquisition.dart';
import 'disposal/disposal.dart';

export 'vehicle.dart';
export 'property.dart';
export 'chargeable_assets.dart';

abstract class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;

  Acquisition acquisition;
  Disposal disposal = new Sale(null, 0);


  Asset transferTo(Entity transferee, Disposal disposal);



}