

import 'package:taxlogic/src/assets/property/residential_property.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/data/stamp_duty_land_tax/stamp_duty_land_tax.dart';
import 'package:taxlogic/src/tax_position/stamp_taxes/stamp_taxes.dart';
import 'package:taxlogic/src/utilities/tax_bands.dart';
import 'package:taxlogic/taxlogic.dart';



class StampDutyLandTax extends StampTaxes {
  TaxBands taxBands = new TaxBands();

  StampDutyLandTax(Transaction transaction) : super(transaction) {

    if(transaction.asset is ResidentialProperty){
      taxBands.bands = StampDutyLandTaxData.residential2019;
      taxBands.topRate = StampDutyLandTaxData.residentialTopRate2019;
    } else {
      taxBands.bands = StampDutyLandTaxData.nonResidential2019;
      taxBands.topRate = StampDutyLandTaxData.nonResidentialTopRate2019;

    }



  }


  @override
  num calculateDuty() => taxBands.tax(transaction.consideration);
}
