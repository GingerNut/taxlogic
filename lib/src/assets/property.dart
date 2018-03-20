import 'chargeable_assets.dart';
import '../accounts/accounts.dart';
import 'asset.dart';
import '../entities/entity.dart';

class Property extends ChargeableAsset{
  Property(Entity entity) : super(entity);
  List<Accounts> accounts = new List();



}