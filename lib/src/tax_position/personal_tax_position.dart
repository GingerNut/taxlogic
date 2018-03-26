
import '../../taxlogic.dart';
import '../tax_year.dart';


class PersonalTaxPosition extends TaxPosition{
  static const String jsonTagCode = "code";
  static const String jsonTagYear = "year";
  static const String jsonTagEarnings = "earnings";
  static const String jsonTagTrade = "trade";
  static const String jsonTagDividend = "dividend";
  static const String jsonTagSavings = "savings";

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

    position.earnings = int.parse(map[jsonTagEarnings]);
    position.trade = int.parse(map[jsonTagTrade]);
    position.dividend = int.parse(map[jsonTagDividend]);
    position.savings = int.parse(map[jsonTagSavings]);

    return position;
  }

  Map toMap(){
    Map jsonMap = {
      jsonTagCode: entity.code,
      jsonTagYear: period.end.year.toString(),
      jsonTagEarnings: earnings.toString(),
      jsonTagTrade: trade.toString(),
      jsonTagDividend: dividend.toString(),
      jsonTagSavings: savings.toString(),
    };

    return jsonMap;
  }



  @override
  adjustPropertyProfit(IncomeAndExpenditureProperty accounts) {
      propertyIncome += accounts.interestRestriction;
      propertyTaxCredit += accounts.taxCredit;
  }
}