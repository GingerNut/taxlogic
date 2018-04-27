import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/transaction_history.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/assets/property/property.dart';


class ResidentialProperty extends Property{

  bool mainHome = false;


  List<Period> _mainResidencePeriods = new List();
  num residenceRelief;

  ResidentialProperty(Entity entity) : super(entity);

  @override
  num adjustGain(Entity entity, num gain){



    gain = calculateMainResidenceRelief(entity, gain);

    return gain;
  }

  void addResidencePeriod(Period period){

    _mainResidencePeriods.add(period);

    refreshGain();

  }

  void setAllMainResidence(Entity entity){
    addResidencePeriod(new Period(acquisitionDate(entity), disposalDate(entity)));
    refreshGain();
  }

  num calculateMainResidenceRelief(Entity entity, num gain){
    if(_mainResidencePeriods.length ==0) return gain;

    Period ownership = new Period(acquisitionDate(entity), disposalDate(entity));

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

     _mainResidencePeriods.add(Period.monthsTo(disposalDate(entity), 18));

    List<Period> _nonOverlappingPeriods = Period.consolidatePeriods(_mainResidencePeriods);

      int daysInResidence = 0;

      _nonOverlappingPeriods.forEach((period){
        daysInResidence += period.days;
      });

      residenceRelief = gain * daysInResidence / ownership.days;

      return gain - residenceRelief;
  }

  ResidentialProperty getProperty(Entity entity) => new ResidentialProperty(entity);

}