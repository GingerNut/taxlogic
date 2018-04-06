import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/company/company_tax_position.dart';
import 'package:taxlogic/src/utilities/period.dart';


class CompanyAccountingPeriod extends CompanyTaxPosition{
  CompanyAccountingPeriod(Company company, Period period) : super(company) {

    this.period = period;
  }









}