
import '../entities/entity.dart';
import '../assets/chargeable_assets.dart';
import '../period.dart';
import '../data/tax_data.dart';
import '../taxation/capital_gains.dart';


abstract class TaxPosition{
  Entity entity;
  Period period;
  TaxPosition previousTaxPosition;
  TaxData taxData;
  CapitalGains capitalGainsTaxPosition;

  List<ChargeableAsset> disposals = new List();


  TaxPosition(this.entity);

  refreshDisposals() {
    disposals.clear();
    entity.assets.forEach((asset) {
      if(asset.saleDate != null){
        if(period.includes(asset.saleDate)){
          disposals.add(asset);
        }
      }
    });

  }


  num get basicRateAvailable;

}