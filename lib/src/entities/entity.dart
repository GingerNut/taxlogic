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
  List<ChargeableAsset> assets = new List();


}