
import 'capital_gains_tax_data_2016.dart';
import 'capital_gains_tax_data_2017.dart';
import 'capital_gains_tax_data_2018.dart';
import 'capital_gains_tax_data_2019.dart';
import '../../entities/entity.dart';

abstract class CapitalGainsTaxData{

  num CapitalGainsAnnualExempt;
  num CapitalGainsAnnualExemptTrustees;
  num CapitalGainsBasicRateRes;
  num CapitalGainsBasicRateNonRes;
  num CapitalGainsHigherRateRes;
  num CapitalGainsHigherRateNonRes;
  num CapitalGainsEntrepreneur;

  static CapitalGainsTaxData get(int year){

    CapitalGainsTaxData taxData;

    if(year > 2019) year = 2019;

    switch(year){
      case 2016:
        taxData = new CapitalGainsTaxData2016();
        break;

      case 2017:
        taxData = new CapitalGainsTaxData2017();
        break;

      case 2018:
        taxData = new CapitalGainsTaxData2018();
        break;

      case 2019:
        taxData = new CapitalGainsTaxData2019();
        break;
    }

    return taxData;

  }


}
