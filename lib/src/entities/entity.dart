import '../assets/chargeable_assets.dart';

enum Class{
      individual,
      company,
      partnership,
      trust,
}

class Entity{
  String code;
  Class type;

  List<Entity> children = new List();
  List<ChargeableAsset> assets = new List();


}