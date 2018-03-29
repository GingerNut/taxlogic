import '../assets/asset.dart';
import '../assets/activity.dart';
import '../date.dart';

enum Class{
      individual,
      company,
      partnership,
      trust,
}

abstract class Entity{
  String code;
  Class type;

  Date birth;
  Date death;

  List<Entity> children = new List();
  List<Asset> assets = new List();
  List<Activity> activities = new List();


  num taxPayble(Date periodend);
}
