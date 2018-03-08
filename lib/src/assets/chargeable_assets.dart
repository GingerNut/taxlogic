
import '../period.dart';
import '../date.dart';


class ChargeableAsset{
  String name;
  String description;
  num cost;
  Date purchaseDate;
  Date saleDate;
  num proceeds;
  num _taxableGain;
  num _totalImprovements;
  num lossAllocated = 0;
  num basicRateAllocated = 0;
  bool entrepreneurRelief = false;
  bool rolloverReliefAsset = false;
  bool residentialProperty = false;
  bool exempt = false;

  List<Improvement> _improvements = new List();
  List<Period> _mainResidencePeriods = new List();


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

    _taxableGain = proceeds - cost - totalImprovements;

    return _taxableGain;
  }




  addResidencePeriod(Date from, Date to){
    residentialProperty = true;

    _mainResidencePeriods.add(new Period(from,to));

    refreshGain();

  }

  setAllMainResidence(){
    addResidencePeriod(purchaseDate, saleDate);
    refreshGain();
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

