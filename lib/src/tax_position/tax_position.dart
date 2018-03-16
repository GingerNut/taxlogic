
import '../entities/entity.dart';
import '../assets/chargeable_assets.dart';
import '../period.dart';
import '../data/tax_data.dart';
import '../taxation/capital_gains_base.dart';


abstract class TaxPosition{
  Entity person;
  Period taxYear;
  TaxPosition previousTaxPosition;
  TaxData taxData;
  CapitalGainsBase capitalGainsTaxPosition;

  List<ChargeableAsset> disposals = new List();


  TaxPosition(this.person);

  refreshDisposals() {
    disposals.clear();
    person.assets.forEach((asset) {
      if(asset.saleDate != null){
        if(taxYear.includes(asset.saleDate)){
          disposals.add(asset);
        }
      }
    });

  }


  num get basicRateAvailable;

}