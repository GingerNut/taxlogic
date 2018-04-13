import '../assets/asset.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/utilities/date.dart';

import '../tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/utilities/period.dart';

export 'package:taxlogic/src/entities/company/company.dart';
export 'person.dart';
export 'pension.dart';
export 'unknown.dart';

abstract class Entity{

  static const INDIVIDUAL = 0;
  static const COMPANY = 1;
  static const PARTNERSHIP = 2;
  static const TRUST = 3;
  static const PENSION = 4;
  static const UNKNOWN = 5;

  String code;
  String name;
  String narrative;
  int type;

  Date birth;
  Date death;

  List<TaxPosition> taxPeriods = new List();
  List<Entity> children = new List();
  List<Asset> assets = new List();
  List<Activity> activities = new List();

  TaxPosition taxYear(int taxYearEnd);

  PeriodCollection getTaxPeriods(Period period);

  Activity getActivityByName(String name){
    Activity named;

    activities.forEach((e){
      if(e.name == name) named = e;
    });

    return named;

  }

  Property getAssetById(String name) {

    Property named;

    assets.forEach((e){
      if(e.name == name && e is Property) named = e;
    });

    return named;


  }

}
