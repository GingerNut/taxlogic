import '../data/tax_data.dart';

import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import '../entities/entity.dart';
import 'dart:math';
import 'asset.dart';


class ChargeableAsset extends Asset{
  num _taxableGain;
  num _totalImprovements;
  num lossAllocated = 0;
  num basicRateAllocated = 0;
  num annualExemptionAllocated = 0;
  bool entrepreneurRelief = false;
  bool rolloverReliefAsset = false;
  bool exempt = false;

  ChargeableAsset(Entity entity) : super(entity);

  List<Improvement> _improvements = new List();
  List<ChargeableAsset> disposals = new List();

  num get totalImprovements{

    if(_totalImprovements != null) return _totalImprovements;

    _totalImprovements = 0;

    _improvements.forEach((improvement){
      _totalImprovements += improvement.cost;
    });

    return _totalImprovements;
}

  num taxableGain(Entity entity){

    num gain = disposalConsideration(entity) - acquisitionConsideration(entity) - totalImprovements;

    gain = adjustGain(entity, gain);

    gain  = Utilities.roundIncome(gain);


    if(owner(disposalDate(entity)+ -1).type == Entity.COMPANY && gain > 0){

      num indexation = min(TaxData.IndexationFactor(acquisitionDate(entity), disposalDate(entity)) * acquisitionConsideration(entity), gain);

      gain -= indexation ;

    }

    return gain;
  }


  num adjustGain(Entity entity, num gain)=> gain;


  addImprovement(Improvement improvement){
    _improvements.add(improvement);
    _totalImprovements = null;
    refreshGain();
  }

  void refreshGain(){
    _taxableGain = null;
  }





}

class Improvement{

  String description;
  num cost;
  Date date;

  Improvement(this.cost, {this.date, this.description});

}

