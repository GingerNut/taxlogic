
import 'income_tax_data_2016.dart';
import 'income_tax_data_2017.dart';
import 'income_tax_data_2018.dart';
import 'income_tax_data_2019.dart';
import 'income_tax_scotland_data_2016.dart';
import 'income_tax_scotland_data_2017.dart';
import 'income_tax_scotland_data_2018.dart';
import 'income_tax_scotland_data_2019.dart';

abstract class IncomeTaxData{

  num PersonalAllowanceDefault;
  num StarterRateBand;
  num BasicRateBand;
  num IntermediateRateBand;
  num PersonalAllowanceTaperThreshold;

  num AdditionalRateLimit;
  num StarterRate;
  num BasicRate;
  num IntermediateRate;
  num HigherRate;
  num AdditionalRate;

  static IncomeTaxData get(int year, bool scotland){

    IncomeTaxData taxData;

    switch(year){
      case 2016:
        scotland ? taxData = new IncomeTaxDataScotland2016() : taxData = new IncomeTaxData2016();
        break;

      case 2017:
        scotland ? taxData = new IncomeTaxDataScotland2017() : taxData = new IncomeTaxData2017();
        break;

      case 2018:
        scotland ? taxData = new IncomeTaxDataScotland2018() : taxData = new IncomeTaxData2018();
        break;

      case 2019:
        scotland ? taxData = new IncomeTaxDataScotland2019() : taxData = new IncomeTaxData2019();
        break;
    }

    return taxData;

  }


}
