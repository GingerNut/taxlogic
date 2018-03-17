
import '../entities/entity.dart';
import '../assets/chargeable_assets.dart';
import '../period.dart';
import '../data/tax_data.dart';
import '../taxation/capital_gains.dart';
import '../tax_position/company_tax_position.dart';



abstract class TaxPosition{
  Entity entity;
  Period period;
  TaxPosition previousTaxPosition;

  CapitalGains capitalGainsTaxPosition;

  List<ChargeableAsset> disposals = new List();


  TaxPosition(this.entity, this.period);

  refreshDisposals() {
    disposals.clear();
    entity.assets.forEach((asset) {
      if(asset.saleDate is ChargeableAsset && asset.saleDate != null){
        if(period.includes(asset.saleDate)){
          disposals.add(asset);
        }
      }
    });

  }


  num get basicRateAvailable;

}