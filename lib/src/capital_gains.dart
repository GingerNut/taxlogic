import 'tax_position.dart';
import 'person.dart';

class CapitalGainsTaxPosition{
  Person person;
  TaxPosition taxPosition;
  num _totalGains;
  num _capitalLosses;
  num _capitalLossesBroughtForward = 0;
  num capitalLossesCarriedForward = 0;

  num get totalGains {

    taxPosition.refreshDisposals();

    calculate();
    if(_totalGains - _capitalLosses - _capitalLossesBroughtForward> 0) {
      return _totalGains - _capitalLosses - _capitalLossesBroughtForward;
    }
    else {

      capitalLossesCarriedForward = _capitalLossesBroughtForward + _totalGains - _capitalLosses;

      return 0;
    }
  }

  CapitalGainsTaxPosition(this.person, this.taxPosition){
    if(taxPosition.previousTaxPosition != null){
      _capitalLossesBroughtForward = taxPosition.previousTaxPosition.capitalGainsTaxPosition.capitalLossesCarriedForward;
    }

    taxPosition.refreshDisposals();
  }


  void calculate(){

    _totalGains = 0;
    _capitalLosses = 0;

    taxPosition.disposals.forEach((asset){

      num gain = asset.calculateGain();

      if(gain > 0){
        _totalGains += gain;
      } else{
        _capitalLosses -= gain;

      }

    });

  }







}