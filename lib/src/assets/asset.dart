import '../entities/entity.dart';
import 'acquisition/acquisition.dart';
import 'disposal/disposal.dart';
import 'package:taxlogic/src/residence/country.dart';

export 'vehicle.dart';
export 'package:taxlogic/src/assets/property/property.dart';
export 'chargeable_assets.dart';

abstract class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;
  int locus = Country.GBR;

  Acquisition acquisition;
  Disposal disposal = new Sale(null, 0);


  Asset transferTo(Entity transferee, Disposal disposal);



}