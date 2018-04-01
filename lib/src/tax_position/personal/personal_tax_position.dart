
import '../tax_position.dart';
import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/entities/entity.dart';
import '../../data/tax_data.dart';


abstract class PersonalTaxPosition extends TaxPosition{
  PersonalTaxPosition(Person person, this.year) : super(person);

  final int year;
  num basicRateBeforeDividends;

  num get personalAllowance {
    num allowance = TaxData.PersonalAllowanceDefault(year, (entity as Person).scotland);

    if(totalIncome > TaxData.PersonalAllowanceTaperThreshold(year, (entity as Person).scotland)){

      allowance -= totalIncome / 2;

      allowance.clamp(0, allowance);
    }
    return allowance;
  }

  num get totalIncome {
    num totalIncome = 0;

    income.forEach((inc){
      totalIncome += inc.income;
    });
    return totalIncome;
  }

  num get taxCredit {
    num taxCredit = 0;

    income.forEach((inc){
      taxCredit += inc.taxCredit;
    });
    return taxCredit;
  }

  num get taxDeducted {
    num taxDeducted = 0;

    income.forEach((inc){
      taxDeducted += inc.taxDeducted;
    });
    return taxDeducted;
  }

  num get tax{

    num tax = 0;

    tax += IncomeTax(this);

    tax += DividendTax(this);

    tax += NationalInsurance(this);

    tax += CapitalGainsTax(this);

    tax -= taxCredit.clamp(0,taxCredit);

    tax -= taxDeducted;

    return tax;
  }

}