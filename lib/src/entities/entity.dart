import '../assets/chargeable_assets.dart';
import '../date.dart';

enum Class{
      individual,
      company,
      partnership,
      trust,
}

class Entity{
  String code;
  Class type;

  Date birth;
  Date death;

  List<Entity> children = new List();
  List<ChargeableAsset> assets = new List();


}