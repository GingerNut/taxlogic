import 'income.dart';
import '../entities/entity.dart';
import '../tax_position/company_tax_position.dart';
import '../date.dart';
import '../data/tax_data.dart';
import '../rate_history.dart';
import '../utilities.dart';


class CorporationTax extends Income{

 num totalProfits = 0;

  CorporationTax(CompanyTaxPosition taxPosition) : super(taxPosition){


  }

  num tax = 0;

 int daysAtFirstRate;
 int daysAtSecondRate;
 int daysInPeriod;



  calculate(){

   totalProfits = (taxPosition as CompanyTaxPosition).income;

   totalProfits += taxPosition.capitalGainsTaxPosition.gains;


   // calculate rate of tax

  List<RatePeriod> periods = TaxData.CompanyRatePeriods((taxPosition as CompanyTaxPosition).period);

  tax = 0;

  periods.forEach((period){
   tax += totalProfits * period.period.duration/(taxPosition as CompanyTaxPosition).period.duration * period.rate;
  });

  tax = Utilities.roundTax(tax);

  }


  List<String> narrative(){
   List<String> narrative = new List();

   List<RatePeriod> periods = TaxData.CompanyRatePeriods((taxPosition as CompanyTaxPosition).period);

  num tax;

   periods.forEach((period){
    tax = (taxPosition as CompanyTaxPosition).income * period.period.duration/(taxPosition as CompanyTaxPosition).period.duration * period.rate;
    tax = Utilities.roundTax(tax);

    String line = 'Period from ${period.period.start.day} ${period.period.start.month} ${period.period.start.year} ';
    line += 'to ${period.period.end.day} ${period.period.end.month} ${period.period.end.year}';
    line +=' at ${period.rate * 100}% ';
    line += ' $tax';

    narrative.add(line);

   });

  return narrative;

  }


}