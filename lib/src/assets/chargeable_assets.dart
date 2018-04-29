import '../data/tax_data.dart';

import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history/transaction_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import '../entities/entity.dart';
import 'dart:math';
import 'asset.dart';


class ChargeableAsset extends Asset{
  bool gainValid = false;
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

    List<Transaction> sales = transactions.disposal(entity);

    num gain = 0;

    sales.forEach((sale) => gain += sale.calculateGain(entity));

   return gain;

  }


  num adjustGain(Entity entity, num gain)=> gain;


  addImprovement(Improvement improvement){
    _improvements.add(improvement);
    refreshGain();
  }

  void refreshGain(){
      gainValid = false;
  }





}

class Improvement{

  String description;
  num cost;
  Date date;

  Improvement(this.cost, {this.date, this.description});

}

