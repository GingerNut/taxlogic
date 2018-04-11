import '../entities/entity.dart';
import 'acquisition/acquisition.dart';
import 'disposal/disposal.dart';

export 'vehicle.dart';

abstract class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;

  Acquisition acquisition = new Purchase();
  Disposal disposal = new Sale();

}