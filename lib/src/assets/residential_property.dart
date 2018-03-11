import '../period.dart';
import 'property.dart';

class ResidentialProperty extends Property{

  List<Period> _mainResidencePeriods = new List();
  num residenceRelief;

  ResidentialProperty(){
    residentialProperty = true;
  }


  @override
  num adjustGain(num gain){

    gain = calculateMainResidenceRelief(gain);

    return gain;
  }

  void addResidencePeriod(Period period){

    _mainResidencePeriods.add(period);

    refreshGain();

  }

  void setAllMainResidence(){
    addResidencePeriod(new Period(purchaseDate, saleDate));
    refreshGain();
  }

  num calculateMainResidenceRelief(num gain){
    if(_mainResidencePeriods.length ==0) return gain;

    Period ownership = new Period(purchaseDate, saleDate);

    // if a loss cannot be allowable

    if(gain < 0) return 0;

    // if less than 18 months

    if(ownership.completeMonths() < 18) {
      return 0;
    }

    // if whole period of ownership occupied

    if(_mainResidencePeriods.length == 1) {
      Period occupation = _mainResidencePeriods[0];

      if(occupation.days == ownership.days) return 0;
    }

    // consolidate main residence periods to find length compared to ownership

     _mainResidencePeriods.add(Period.monthsTo(saleDate, 18));

    List<Period> _nonOverlappingPeriods = Period.consolidatePeriods(_mainResidencePeriods);

      int daysInResidence = 0;

      _nonOverlappingPeriods.forEach((period){
        daysInResidence += period.days;
      });

      residenceRelief = gain * daysInResidence / ownership.days;

      return gain - residenceRelief;
  }


}