import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/acquisition/stamp_taxes/stamp_taxes.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
export 'purchase.dart';


abstract class Acquisition{
  Acquisition(this.asset){
    if(asset is Property) stamp = new StampDutyLandTax(this);
    else if(asset is ShareHolding) stamp = new StampDuty(this);
  }

  final Asset asset;

  Date date;
  num cost = 0;

  StampTaxes stamp;

}