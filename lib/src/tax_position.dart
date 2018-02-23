import 'income_tax.dart';
import 'national_insurance.dart';
import 'person.dart';

class TaxPosition{
  Person person;
  int year;

  num earnings = 0;
  num trade = 0;
  num dividend = 0;

  IncomeTaxPosition incomeTax;
  NationalInsurancePosition nicPosition;

  TaxPosition(this.person, this.year){
    incomeTax = new IncomeTaxPosition(person, this);
    nicPosition = new NationalInsurancePosition(person, this);

  }


}