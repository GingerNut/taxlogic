
import '../entities/entity.dart';
import 'package:taxlogic/src/tax_position/company/company_tax_position.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../data/tax_data.dart';
import 'package:taxlogic/src/utilities/rate_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';


class CorporationTax{

 num totalProfits = 0;

  CorporationTax(CompanyTaxPosition taxPosition){


  }

 int daysAtFirstRate;
 int daysAtSecondRate;
 int daysInPeriod;



  num calculate(){

   num tax = 0;

   totalProfits = 1;

   totalProfits += 0;


   // calculate rate of tax

  List<RatePeriod> periods = TaxData.CompanyRatePeriods((taxPosition as CompanyTaxPosition).period);


  periods.forEach((period){
   tax += totalProfits * period.period.duration/(taxPosition as CompanyTaxPosition).period.duration * period.rate;
  });

  tax = Utilities.roundTax(tax);

  return tax;
  }


 List<List<String>> narrative( List<List<String>> narrative){

   List<String> narrativeLine = new List();

   List<RatePeriod> periods = TaxData.CompanyRatePeriods((taxPosition as CompanyTaxPosition).period);

 num tax = 0;

   periods.forEach((period){
    tax = (taxPosition as CompanyTaxPosition).income * period.period.duration/(taxPosition as CompanyTaxPosition).period.duration * period.rate;
    tax = Utilities.roundTax(tax);

    String line = 'Period from ${period.period.start.day} ${period.period.start.month} ${period.period.start.year} ';
    line += 'to ${period.period.end.day} ${period.period.end.month} ${period.period.end.year}';
    line +=' at ${period.rate * 100}% ';
    line += ' $tax';

    narrativeLine.add(line);

   });

  return narrative;

  }


}