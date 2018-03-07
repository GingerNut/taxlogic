import 'tax_position.dart';
import 'person.dart';
import 'data/capital_gains_tax/capital_gains_tax_data.dart';
import 'dart:math';

class CapitalGainsTaxPosition{
  Person person;
  TaxPosition taxPosition;
  CapitalGainsTaxData taxData;
  num annualExemption;
  num totalGains;
  num capitalLosses;
  num capitalLossesBroughtForward = 0;
  num capitalLossesCarriedForward = 0;
  num netGains = 0;
  num capitalGainsTax = 0;
  num taxableGains = 0;
  num basicRateAmount = 0;


  CapitalGainsTaxPosition(this.person, this.taxPosition){

    taxData = CapitalGainsTaxData.get(taxPosition.year);
    

    if(taxPosition.previousTaxPosition != null){
      capitalLossesBroughtForward = taxPosition.previousTaxPosition.capitalGainsTaxPosition.capitalLossesCarriedForward;
    }

    taxPosition.refreshDisposals();
  }


  void calculate(){

    taxPosition.refreshDisposals();

    annualExemption = taxData.CapitalGainsAnnualExempt;
    netGains = 0;
    capitalGainsTax = 0;

    totalGains = 0;
    capitalLosses = 0;

    taxPosition.disposals.forEach((asset){

      num gain = asset.calculateGain();

      if(gain > 0){
        totalGains += gain;
      } else{
        capitalLosses -= gain;

      }

    });

    // loss relief

    netGains = totalGains;
    taxableGains = 0;

    num capitalLossRemaining = capitalLosses;

    if(totalGains > annualExemption){

      if(capitalLosses > 0){
        num capitalLossUsed = min(capitalLosses, netGains - annualExemption);

        netGains -= capitalLossUsed;
        capitalLossRemaining -= capitalLossUsed;

      }
      
      if(capitalLossesBroughtForward > 0){

        num capitalLossUsed = min(capitalLossesBroughtForward, netGains - annualExemption);

        netGains -= capitalLossUsed;
        capitalLossesBroughtForward -= capitalLossUsed;
        
      }
      
      capitalLossesCarriedForward = capitalLossesBroughtForward + capitalLossRemaining;



    } else {
      
      annualExemption = totalGains;
    
    }

    taxableGains = netGains - annualExemption;


    // calculate tax
    
    // allocate taxable gains to lowest rates

    // first find basic rate amount

    basicRateAmount = taxPosition.incomeTax.getBasicRateAvailable();

  // allocate taxable gains in best way for taxpayer



  }







}