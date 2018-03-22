import 'package:taxlogic/src/entities/company.dart';
import '../assets/chargeable_assets.dart';
import '../utilities.dart';
import '../tax_position/company_tax_position.dart';
import 'capital_gains.dart';
import '../data/tax_data.dart';

class CompanyCapitalGainsPosition extends CapitalGains{

  CompanyCapitalGainsPosition(CompanyTaxPosition taxPosition) : super(taxPosition);

  void allocateLosses(){

    num lossesToAllocate = totalLossUsed;

    while(lossesToAllocate > 0){

      taxPosition.disposals.forEach((asset){
        if(lossesToAllocate < asset.taxableGain){
          asset.lossAllocated = lossesToAllocate;
          lossesToAllocate = 0;
        } else {
          asset.lossAllocated = asset.taxableGain;
          lossesToAllocate -= asset.lossAllocated;
        }

      });
    }
  }

  void calculateTax() {

  }
  @override
  List<List<String>> narrative(List<List<String>> narrative) {
    // TODO: implement narrative
  }
}