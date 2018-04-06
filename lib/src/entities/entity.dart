import '../assets/asset.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'person.dart';
import 'partnership.dart';
import 'company.dart';
import 'trust.dart';
import '../tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/utilities/period.dart';
export 'company.dart';
export 'person.dart';

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


  static Entity get(int type){
    switch(type){

      case Entity.INDIVIDUAL: return new Person();
        break;

      case Entity.COMPANY: return new Company();
        break;

      case Entity.PARTNERSHIP: return new Partnership();
        break;

      case Entity.TRUST: return new Trust();
        break;
    }
    return null;
  }

}
