
import '../period.dart';
import '../date.dart';


class ChargeableAsset{
  String name;
  String description;
  num cost;
  Date purchaseDate;
  Date saleDate;
  num proceeds;
  bool entrepreneurRelief = false;
  bool rolloverReliefAsset = false;
  bool residentialProperty = false;

  num get totalImprovements{
    num totalImprovements = 0;

    improvements.forEach((improvement){
      totalImprovements += improvement.cost;
    });

    return totalImprovements;
}

  List<Improvement> improvements = new List();
  List<Period> mainResidencePeriods = new List();

  num calculateGain ()=> proceeds - cost - totalImprovements;


  addResidencePeriod(Date from, Date to){
    residentialProperty = true;

    mainResidencePeriods.add(new Period(from,to));

  }

  setAllMainResidence(){
    addResidencePeriod(purchaseDate, saleDate);

  }

}

class Improvement{

  String description;
  num cost;
  Date date;

  Improvement(this.cost, {this.date, this.description});

}

