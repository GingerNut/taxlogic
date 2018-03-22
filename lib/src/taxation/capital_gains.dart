import '../tax_position/tax_position.dart';
import '../assets/chargeable_assets.dart';
import 'dart:math';
import '../data/tax_data.dart';
import 'taxation.dart';

abstract class CapitalGains extends Taxation{

  num capitalLossesBroughtForward = 0;
  num capitalLossesCarriedForward = 0;
  num totalGains;
  num annualExemption;
  num basicRateAmount = 0;
  num capitalLosses;
  num netGains = 0;
  num capitalGainsTax = 0;
  num taxableGains = 0;

  num totalLossUsed = 0;


  CapitalGains(TaxPosition taxPosition) : super(taxPosition){

    if(taxPosition.previousTaxPosition != null){
      capitalLossesBroughtForward = taxPosition.previousTaxPosition.capitalGainsTaxPosition.capitalLossesCarriedForward;
    }
  }

  get gains {

    calculate();

    num _gains = 0;

    taxPosition.disposals.forEach((asset){
      _gains += asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated;
    });

    return _gains;
  }

  void calculate(){
    taxPosition.refreshDisposals();

    analyseDisposals();

    allocateLosses();

    calculateTax();
  }

  void analyseDisposals(){

    taxPosition.refreshDisposals();
    annualExemption = TaxData.CapitalGainsAnnualExempt(taxPosition.period.end.year, taxPosition.entity);

    netGains = 0;
    capitalGainsTax = 0;

    totalGains = 0;
    capitalLosses = 0;

    taxPosition.disposals.forEach((asset){

      if(asset.taxableGain > 0){
        totalGains += asset.taxableGain;
      } else{
        capitalLosses -= asset.taxableGain;

      }

    });

    // loss relief

    netGains = totalGains - capitalLosses;
    taxableGains = 0;
    capitalLossesCarriedForward = capitalLossesBroughtForward;

    num currentCapitalLossUsed = 0;
    num broughtForwardLossUsed = 0;
    totalLossUsed = 0;

    currentCapitalLossUsed = min(capitalLosses, totalGains);

    if(netGains > 0){

      if(capitalLossesBroughtForward > 0 && netGains > annualExemption){

        broughtForwardLossUsed = min(capitalLossesBroughtForward, netGains - annualExemption);

        netGains -= broughtForwardLossUsed;
        capitalLossesCarriedForward -= broughtForwardLossUsed;

      }

      //capitalLossesCarriedForward = capitalLossesBroughtForward - broughtForwardLossUsed;

      totalLossUsed = currentCapitalLossUsed + broughtForwardLossUsed;

    } else {
      capitalLossesCarriedForward -= netGains;

    }

    if(netGains < annualExemption){
      annualExemption = netGains;
    }

    taxableGains = netGains - annualExemption;

  }

  void allocateLosses();

  void calculateTax();



}