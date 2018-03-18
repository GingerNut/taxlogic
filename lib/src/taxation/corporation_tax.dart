import 'income.dart';
import '../entities/entity.dart';
import '../tax_position/company_tax_position.dart';
import '../date.dart';
import '../data/tax_data.dart';
import '../rate_history.dart';


class CorporationTax extends Income{
 final CompanyTaxPosition taxPosition;

  CorporationTax(Entity entity, this.taxPosition) : super(entity);

  num tax = 0;

 int daysAtFirstRate;
 int daysAtSecondRate;
 int daysInPeriod;



  calculate(){




   // calculate rate of tax

  List<RatePeriod> periods = TaxData.CompanyRatePeriods(taxPosition.period);

  tax = 0;

  periods.forEach((period){
   tax += taxPosition.income * period.period.days/365 * period.rate;
  });

  }



}