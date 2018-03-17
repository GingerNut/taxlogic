import 'income.dart';
import '../entities/entity.dart';
import '../tax_position/company_tax_position.dart';
import '../date.dart';
import '../data/tax_data.dart';


class CorporationTax extends Income{
 final CompanyTaxPosition taxPosition;

  CorporationTax(Entity entity, this.taxPosition) : super(entity);

  num tax = 0;
  num rate;
 int daysAtFirstRate;
 int daysAtSecondRate;
 int daysInPeriod;



  calculate(){




   // calculate rate of tax

   Date middle31March = taxPosition.period.start.next(31, 3);

   daysAtFirstRate = middle31March - taxPosition.period.start;
   daysAtSecondRate = taxPosition.period.end - middle31March;
   daysInPeriod = taxPosition.period.end - taxPosition.period.start;

   rate = daysAtFirstRate / daysInPeriod * TaxData.CompanyMainRate(taxPosition.period.start) + daysAtSecondRate / daysInPeriod * TaxData.CompanyMainRate(taxPosition.period.end);

   tax = 0;

   tax += taxPosition.income * rate;

  }



}