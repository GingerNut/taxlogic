import 'tax_position.dart';
import 'person.dart';
import 'data/capital_gains_tax/capital_gains_tax_data.dart';
import 'dart:math';
import 'assets/chargeable_assets.dart';

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

      if(asset.taxableGain > 0){
        totalGains += asset.taxableGain;
      } else{
        capitalLosses -= asset.taxableGain;

      }

    });

    // loss relief

    netGains = totalGains - capitalLosses;
    taxableGains = 0;

    num capitalLossRemaining = capitalLosses;

    num currentCapitalLossUsed = 0;
    num broughtForwardLossUsed = 0;
    num totalLossUsed = 0;

    currentCapitalLossUsed = min(capitalLosses, totalGains);

    capitalLossRemaining -= currentCapitalLossUsed;

    if(netGains > 0){


      if(capitalLossesBroughtForward > 0 && netGains > annualExemption){

        broughtForwardLossUsed = min(capitalLossesBroughtForward, netGains - annualExemption);

        netGains -= broughtForwardLossUsed;
        capitalLossesBroughtForward -= broughtForwardLossUsed;
        
      }
      
      capitalLossesCarriedForward = capitalLossesBroughtForward;


      totalLossUsed = currentCapitalLossUsed + broughtForwardLossUsed;


    } else {
      capitalLossesCarriedForward -= netGains;

     }

     if(netGains < annualExemption){
      annualExemption = netGains;
     }

    taxableGains = netGains - annualExemption;

    // calculate tax
    
    // allocate taxable gains to lowest rates

    // first find basic rate amount

    basicRateAmount = taxPosition.incomeTax.getBasicRateAvailable();

  // allocate taxable gains in best way for taxpayer

    num lossesToAllocate = totalLossUsed;

    //sort disposals into loss priority - residential first, non residential next then entrepreneur

    List<ChargeableAsset> residential = new List();
    List<ChargeableAsset> nonResidential = new List();
    List<ChargeableAsset> entrepreneur = new List();

    taxPosition.disposals.forEach((asset){
      if(asset.taxableGain > 0){
        if(asset.residentialProperty) residential.add(asset);
        else if (asset.entrepreneurRelief) entrepreneur.add(asset);
        else nonResidential.add(asset);
      }

    });

    List<ChargeableAsset> priority;

    if(residential.length > 0) priority = residential;
    else if (nonResidential.length > 0) priority = nonResidential;
    else priority = entrepreneur;

    while(lossesToAllocate > 0 && priority != null){

      priority.forEach((asset){
        if(lossesToAllocate < asset.taxableGain){
          asset.lossAllocated = lossesToAllocate;
          lossesToAllocate = 0;
        } else {
          asset.lossAllocated = asset.taxableGain;
          lossesToAllocate -= asset.lossAllocated;
        }

      });

      if(priority == residential) priority = nonResidential;
      else if(priority == nonResidential) priority = entrepreneur;
      else priority = null;
    }



  }







}