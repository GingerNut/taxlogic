import '../data/tax_data.dart';
import '../period.dart';
import '../date.dart';
import '../utilities.dart';
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
  bool residentialProperty = false;
  bool exempt = false;

  ChargeableAsset(Entity entity) : super(entity);

  List<Improvement> _improvements = new List();

  num get totalImprovements{

    if(_totalImprovements != null) return _totalImprovements;

    _totalImprovements = 0;

    _improvements.forEach((improvement){
      _totalImprovements += improvement.cost;
    });

    return _totalImprovements;
}

  num get taxableGain{

    if(_taxableGain != null) return _taxableGain;

    num gain = proceeds - cost - totalImprovements;

    gain = adjustGain(gain);

    gain  = Utilities.roundIncome(gain);

    _taxableGain = gain;

    if(entity.type == Entity.COMPANY && _taxableGain > 0){

      num indexation = min(TaxData.IndexationFactor(purchaseDate, saleDate) * cost, _taxableGain);

      _taxableGain -= indexation ;

    }

    return _taxableGain;
  }


  num adjustGain(num gain){

    return gain;
  }


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

