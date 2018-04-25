import '../assets/asset.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/residence/residence_history.dart';
import 'package:taxlogic/src/utilities/date.dart';

import '../tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/history/transaction_history.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/utilities/period.dart';

export 'package:taxlogic/src/entities/company/company.dart';
export 'package:taxlogic/src/entities/individual/person.dart';
export 'pension.dart';
export 'unknown.dart';
export 'joint_owners.dart';

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

  void addAsset(Asset asset)=> assets.add(asset);

  void addCreationTransaction(Asset asset) {
    Transaction transaction = new Transaction(asset)
      ..buyer = this
      ..consideration = 0;

    asset.onTransaction(transaction);

    asset.transactions.add(new TransactionChange(transaction));
  }

  ResidenceHistory residence = new ResidenceHistory();

  TaxPosition taxYear(int taxYearEnd);

  PeriodCollection getTaxPeriods(Period period);

  Activity getActivityByName(String name){
    Activity named;

    activities.forEach((e){
      if(e.name == name) named = e;
    });

    return named;

  }

  Asset getAssetById(String name) {

    Asset named;

    assets.forEach((e){
      if(e.name == name) named = e;
    });

    return named;


  }



}
