import '../data/tax_data.dart';

import 'package:taxlogic/src/assets/gain_valid.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/assets/transaction/transaction_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import '../entities/entity.dart';
import 'dart:math';
import 'asset.dart';


class ChargeableAsset extends Asset{
  List<GainValid> _gainValid = new List();
  num lossAllocated = 0;
  num basicRateAllocated = 0;
  num annualExemptionAllocated = 0;
  bool entrepreneurRelief = false;
  bool rolloverReliefAsset = false;
  bool exempt = false;

  ChargeableAsset(Entity entity) : super(entity);

  List<Improvement> _improvements = new List();
  List<ChargeableAsset> disposals = new List();

  setGainValid(Entity entity) => _getGainValid(entity).valid = true;

  setGainInvalid(Entity entity)=> _getGainValid(entity).valid = false;

  bool isGainValid(Entity entity)=> _getGainValid(entity).valid;

  _getGainValid(Entity entity){
    GainValid valid;

    _gainValid.forEach((v) {if(v.entity == entity) valid = v;});

    if(valid == null) valid = new GainValid(entity);

    return valid;
  }

  num totalImprovements(Period period){

    num improvements = 0;

    _improvements.forEach((improvement){
      if(period == null) improvements += improvement.cost;
      else if(period.includes(improvement.date))improvements += improvement.cost;
    });

    return improvements;
}

  num taxableGain(Entity entity){

    List<Transaction> sales = transactions.disposal(entity);

    num gain = 0;

    sales.forEach((sale) => gain += sale.calculateGain(entity));

   return gain;

  }


  num adjustGain(Entity entity, num gain)=> gain;


  addImprovement(Entity entity, Improvement improvement){
    _improvements.add(improvement);
    setGainInvalid(entity);
  }


}

class Improvement{
  Entity entity;
  String description;
  num cost;
  Date date;

  Improvement(this.entity, this.cost, {this.date, this.description});

}

