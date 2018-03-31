
import '../../taxlogic.dart';
import '../tax_year.dart';


class PersonalTaxPosition extends TaxPosition{

  num earnings = 0;
  num trade = 0;
  num dividend = 0;
  num savings = 0;
  num capitalGains = 0;


  NationalInsurancePosition nicPosition;


  num get basicRateAvailable{
    return (incomeTaxPosition as IncomeTaxPosition).getBasicRateAvailable();
  }

  PersonalTaxPosition(Person person, int year) : super (person, new TaxYear(year)){
    period = new TaxYear(year);
    incomeTaxPosition = new IncomeTaxPosition(this);
    nicPosition = new NationalInsurancePosition(this);
    capitalGainsTaxPosition = new PersonalCapitalGainsPosition(this);
  }


  static PersonalTaxPosition fromMap(Map map, person){

    PersonalTaxPosition position = new PersonalTaxPosition(person, int.parse(map['year']));

    position.earnings = int.parse(map[TaxPosition.jsonTagEarnings]);
    position.trade = int.parse(map[TaxPosition.jsonTagTrade]);
    position.dividend = int.parse(map[TaxPosition.jsonTagDividend]);
    position.savings = int.parse(map[TaxPosition.jsonTagSavings]);

    return position;
  }

  Map toMap(){
    Map jsonMap = {
      TaxPosition.jsonTagCode: entity.code,
      TaxPosition.jsonTagYear: period.end.year.toString(),
      TaxPosition.jsonTagEarnings: earnings.toString(),
      TaxPosition.jsonTagTrade: trade.toString(),
      TaxPosition.jsonTagDividend: dividend.toString(),
      TaxPosition.jsonTagSavings: savings.toString(),
    };

    return jsonMap;
  }



  @override
  adjustPropertyProfit(IncomeAndExpenditureProperty accounts) {
      propertyIncome += accounts.interestRestriction;
      propertyTaxCredit += accounts.taxCredit;
  }
}