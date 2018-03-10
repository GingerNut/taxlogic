import 'chargeable_assets.dart';
import '../period.dart';
import '../date.dart';

class ResidentialProperty extends ChargeableAsset{

  List<Period> _mainResidencePeriods = new List();
  List<Period> _rentalPeriods = new List();
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

    List<Period> _nonOverlappingPeriods = new List();
    List<Period> _overlappingPeriods = new List();


    bool overlapping = false;

    // list all overlapping periods;

    _overlappingPeriods = Period.overlappingPeriods(_mainResidencePeriods);



    _mainResidencePeriods.forEach((period){
      _nonOverlappingPeriods.add(period);

    });

    _overlappingPeriods.forEach((period){

      _nonOverlappingPeriods.remove(period);
    });

      //consolidation



      while(_overlappingPeriods.length > 0){
        bool overlap = false;
        int i = 0;

        Period one = _overlappingPeriods[0];

        while(i < _overlappingPeriods.length){
          i++;

          Period two = _overlappingPeriods[i];

          if(Period.overlap(one, two)>0){
            overlap = true;
            _overlappingPeriods.remove(one);
            _overlappingPeriods.remove(two);
            _overlappingPeriods.add( Period.combinePeriods(one, two));
          }

        }

      if(!overlap){
        _overlappingPeriods.remove(one);
        _nonOverlappingPeriods.add(one);
      }

      }

      int daysInResidence = 0;

      _nonOverlappingPeriods.forEach((period){
        daysInResidence += period.days;
      });

      num exempGain = gain * daysInResidence / ownership.days;


      print (daysInResidence);
      print (ownership.days);


      return gain - exempGain;
  }


}