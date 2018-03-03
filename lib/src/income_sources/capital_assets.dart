
import '../period.dart';
import '../date.dart';


class ChargeableAsset{
  String name;
  String description;
  num cost;
  Date purchaseDate;

  num get totalImprovements{
    num totalImprovements = 0;

    improvements.forEach((improvement){
      totalImprovements += improvement.cost;
    });

    return totalImprovements;
}

  List<Improvement> improvements = new List();
  List<Period> mainResidencePeriods = new List();

  num calculateGain (num proceeds)=> proceeds - cost - totalImprovements;



}

class Improvement{

  String description;
  num cost;
  Date date;

  Improvement(this.cost, {this.date, this.description});

}

