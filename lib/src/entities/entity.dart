import '../assets/asset.dart';
import '../assets/activity.dart';
import '../date.dart';

abstract class Entity{

  static const INDIVIDUAL = 0;
  static const COMPANY = 1;
  static const PARTNERSHIP = 2;
  static const TRUST = 3;

  String code;
  String name;
  String narrative;
  int type;

  Date birth;
  Date death;

  List<Entity> children = new List();
  List<Asset> assets = new List();
  List<Activity> activities = new List();


  num taxPayble(Date periodend);
}
