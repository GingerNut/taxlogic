import 'asset.dart';
import 'chargeable_assets.dart';
import '../entities/entity.dart';

class Investment extends Asset with ChargeableAsset{

  Investment(Entity entity) : super(entity);

}