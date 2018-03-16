import 'package:taxlogic/src/entities/entity.dart';
import '../data/capital_gains_tax/capital_gains_tax_data.dart';
import 'dart:math';
import '../assets/chargeable_assets.dart';
import '../utilities.dart';
import '../tax_position/tax_position.dart';
import 'capital_gains_base.dart';

class CapitalGainsTaxPosition extends CapitalGainsBase{


  CapitalGainsTaxData taxData;


  num taxBasicRateRes = 0;
  num taxBasicRateNonRes = 0;
  num taxBasicRateEnt = 0;
  num taxHigherRateRes = 0;
  num taxHigherRateNonRes = 0;
  num taxHigherRateEnt = 0;



  CapitalGainsTaxPosition(Entity person, TaxPosition taxPosition):super(person, taxPosition){

    taxData = CapitalGainsTaxData.get(taxPosition.taxYear.end.year);
    

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
    capitalLossesCarriedForward = capitalLossesBroughtForward;

    num currentCapitalLossUsed = 0;
    num broughtForwardLossUsed = 0;
    num totalLossUsed = 0;

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

    // calculate tax
    
    // allocate taxable gains to lowest rates

    // first find basic rate amount



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
    
    // allocate annual exemption

    num annualExemptionToAllocate = annualExemption;

    if(residential.length > 0) priority = residential;
    else if (nonResidential.length > 0) priority = nonResidential;
    else priority = entrepreneur;

    while(annualExemptionToAllocate > 0 && priority != null){

      priority.forEach((asset){
        if(annualExemptionToAllocate < asset.taxableGain - asset.lossAllocated){
          asset.annualExemptionAllocated = annualExemptionToAllocate;
          annualExemptionToAllocate = 0;
        } else {
          asset.annualExemptionAllocated = asset.taxableGain - asset.lossAllocated;
          annualExemptionToAllocate -= asset.annualExemptionAllocated;
        }

      });

      if(priority == residential) priority = nonResidential;
      else if(priority == nonResidential) priority = entrepreneur;
      else priority = null;
    }
    
    

    // allocate gains to rates of tax
    basicRateAmount = taxPosition.basicRateAvailable;

    num basicRateToAllocate = basicRateAmount;

    if(residential.length > 0) priority = residential;
    else if (nonResidential.length > 0) priority = nonResidential;
    else priority = entrepreneur;

    while(basicRateToAllocate > 0 && priority != null){

      priority.forEach((asset){
        if(basicRateToAllocate < asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated){
          asset.basicRateAllocated = basicRateToAllocate;
          basicRateToAllocate = 0;
        } else {
          asset.basicRateAllocated = asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated;
          basicRateToAllocate -= asset.basicRateAllocated;
        }

      });

      if(priority == residential) priority = nonResidential;
      else if(priority == nonResidential) priority = entrepreneur;
      else priority = null;
    }
    
    // calculate tax

    taxPosition.disposals.forEach((asset){
      
      if(asset.residentialProperty){
        taxBasicRateRes += asset.basicRateAllocated;
        if(asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated > asset.basicRateAllocated){
          taxHigherRateRes += asset.taxableGain - asset.lossAllocated - asset.basicRateAllocated - asset.annualExemptionAllocated;
        }
        
      } else if (asset.entrepreneurRelief){
        
        taxBasicRateEnt += asset.basicRateAllocated;
        if(asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated> asset.basicRateAllocated){
          taxHigherRateEnt += asset.taxableGain - asset.lossAllocated - asset.basicRateAllocated - asset.annualExemptionAllocated;
        }

      } else {

        taxBasicRateNonRes += asset.basicRateAllocated;
        if(asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated > asset.basicRateAllocated){
          taxHigherRateNonRes += asset.taxableGain - asset.lossAllocated - asset.basicRateAllocated - asset.annualExemptionAllocated;
        }
      }
      });

    tax = 0;

    tax += taxBasicRateRes * taxData.CapitalGainsBasicRateRes;
    tax += taxBasicRateNonRes * taxData.CapitalGainsBasicRateNonRes;
    tax +=  taxBasicRateEnt * taxData.CapitalGainsEntrepreneur;
    tax +=  taxHigherRateRes * taxData.CapitalGainsHigherRateRes;
    tax +=  taxHigherRateNonRes * taxData.CapitalGainsHigherRateNonRes;
    tax +=  taxHigherRateEnt * taxData.CapitalGainsEntrepreneur;

    tax = Utilities.roundTax(tax);
  }







}