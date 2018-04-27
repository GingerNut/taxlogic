import '../data/tax_data.dart';

import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history/transaction_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import '../entities/entity.dart';
import 'dart:math';
import 'asset.dart';


class ChargeableAsset extends Asset{
  num lossAllocated = 0;
  num basicRateAllocated = 0;
  num annualExemptionAllocated = 0;
  bool entrepreneurRelief = false;
  bool rolloverReliefAsset = false;
  bool exempt = false;

  ChargeableAsset(Entity entity) : super(entity);

  List<Improvement> _improvements = new List();
  List<ChargeableAsset> disposals = new List();

  num totalImprovements(Period period){

    num improvements = 0;

    _improvements.forEach((improvement){
      if(period == null) improvements += improvement.cost;
      else if(period.includes(improvement.date))improvements += improvement.cost;
    });

    return improvements;
}

  num taxableGain(Entity entity){

    Date acquisition = acquisitionDate(entity);
    Date disposal = disposalDate(entity);

    Period ownership;

    if(acquisition != null && disposal != null) ownership = new Period(acquisitionDate(entity), acquisitionDate(entity));

    num gain = disposalConsideration(entity) - acquisitionConsideration(entity) - totalImprovements(ownership);

    gain = adjustGain(entity, gain);

    gain  = Utilities.roundIncome(gain);


    if(entity.type == Entity.COMPANY && gain > 0){

      num indexation = min(TaxData.IndexationFactor(acquisitionDate(entity), disposalDate(entity)) * acquisitionConsideration(entity), gain);

      gain -= indexation ;

    }

    return gain;
  }


  num adjustGain(Entity entity, num gain)=> gain;


  addImprovement(Improvement improvement){
    _improvements.add(improvement);
    refreshGain();
  }

  void refreshGain(){

  }





}

class Improvement{

  String description;
  num cost;
  Date date;

  Improvement(this.cost, {this.date, this.description});

}

