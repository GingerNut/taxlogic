import 'package:taxlogic/src/entities/person.dart';
import '../assets/chargeable_assets.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import 'package:taxlogic/src/tax_position/personal/personal_tax_position.dart';
import 'capital_gains.dart';
import '../data/tax_data.dart';

class PersonalCapitalGainsPosition extends CapitalGains{

  num taxBasicRateRes = 0;
  num taxBasicRateNonRes = 0;
  num taxBasicRateEnt = 0;
  num taxHigherRateRes = 0;
  num taxHigherRateNonRes = 0;
  num taxHigherRateEnt = 0;

  PersonalCapitalGainsPosition(PersonalTax2018 taxPosition) : super(taxPosition);

  void allocateLosses(){
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
    basicRateAmount = (taxPosition as PersonalTax2018).basicRateAvailable;

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

  }

  num calculateTax() {
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

    num tax = 0;

    tax += taxBasicRateRes * TaxData.CapitalGainsBasicRateRes(taxPosition.period.end.year);
    tax += taxBasicRateNonRes * TaxData.CapitalGainsBasicRateNonRes(taxPosition.period.end.year);
    tax +=  taxBasicRateEnt * TaxData.CapitalGainsEntrepreneur(taxPosition.period.end.year);
    tax +=  taxHigherRateRes * TaxData.CapitalGainsHigherRateRes(taxPosition.period.end.year);
    tax +=  taxHigherRateNonRes * TaxData.CapitalGainsHigherRateNonRes(taxPosition.period.end.year);
    tax +=  taxHigherRateEnt * TaxData.CapitalGainsEntrepreneur(taxPosition.period.end.year);

    tax = Utilities.roundTax(tax);

    return tax;
  }

  @override
  List<List<String>> narrative(List<List<String>> narrative) {
    // TODO: implement narrative
  }
}