import 'dart:math';
import '../entities/entity.dart';
import '../assets/chargeable_assets.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../data/tax_data.dart';

import '../income/income.dart';

export 'package:taxlogic/src/tax_position/company/company_tax_position.dart';

export 'package:taxlogic/src/tax_position/company/company_accounting_period.dart';

abstract class TaxPosition{
  TaxPosition(this.entity);

  Entity entity;
  Period period;
  TaxPosition previousTaxPosition;

  List<Income> income = new List();
  List<ChargeableAsset> disposals = new List();

  num annualExemption = 0;
  num netGains = 0;
  num totalGains = 0;
  num capitalLosses = 0;
  num totalLossUsed = 0;
  num taxableGains;
  num capitalLossBroughtForward = 0;
  num capitalLossCarriedForward = 0;

  num get tax;

  refreshDisposals() {

    disposals.clear();

    entity.assets.forEach((asset) {
      if(asset is ChargeableAsset && asset.disposalDate(entity) != null){
        if(period.includes(asset.disposalDate(entity))){
          disposals.add(asset);
        }
      }
    });

    entity.activities.forEach((activity) {
      if(activity is ShareHolding && activity.disposalDate(entity) != null){
        if(period.includes(activity.disposalDate(entity))){
          disposals.add(activity);
        }
      }
    });

  }

  void analyseDisposals(){

    refreshDisposals();
    annualExemption = TaxData.CapitalGainsAnnualExempt(period.end.year, entity);

    netGains = 0;

    totalGains = 0;
    capitalLosses = 0;

    disposals.forEach((asset){

      if(asset.taxableGain(entity) > 0){
        totalGains += asset.taxableGain(entity);
      } else{
        capitalLosses -= asset.taxableGain(entity);

      }

    });

    // loss relief

    netGains = totalGains - capitalLosses;
    taxableGains = 0;
    capitalLossCarriedForward = capitalLossBroughtForward;

    num currentCapitalLossUsed = 0;
    num broughtForwardLossUsed = 0;


    currentCapitalLossUsed = min(capitalLosses, totalGains);

    if(netGains > 0){

      if(capitalLossBroughtForward > 0 && netGains > annualExemption){

        broughtForwardLossUsed = min(capitalLossBroughtForward, netGains - annualExemption);

        netGains -= broughtForwardLossUsed;
        capitalLossCarriedForward -= broughtForwardLossUsed;

      }

      totalLossUsed = currentCapitalLossUsed + broughtForwardLossUsed;

    } else {
      capitalLossCarriedForward -= netGains;

    }

    if(netGains < annualExemption){
      annualExemption = netGains;
    }

    taxableGains = netGains - annualExemption;

  }


}