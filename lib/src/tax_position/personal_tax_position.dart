
import '../../taxlogic.dart';


class PersonalTaxPosition extends TaxPosition{
  static const String jsonTagCode = "code";
  static const String jsonTagYear = "year";
  static const String jsonTagEarnings = "earnings";
  static const String jsonTagTrade = "trade";
  static const String jsonTagDividend = "dividend";
  static const String jsonTagSavings = "savings";




  int year;


  num earnings = 0;
  num trade = 0;
  num dividend = 0;
  num savings = 0;
  num capitalGains = 0;

  IncomeTaxPosition incomeTax;
  NationalInsurancePosition nicPosition;


  num get basicRateAvailable{
    return incomeTax.getBasicRateAvailable();
  }

  PersonalTaxPosition(Entity person, this.year) : super (person){
    period = new TaxYear(year);
    incomeTax = new IncomeTaxPosition(person, this);
    nicPosition = new NationalInsurancePosition(person, this);
    capitalGainsTaxPosition = new CapitalGainsTaxPosition(person, this);

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
      jsonTagYear: year.toString(),
      jsonTagEarnings: earnings.toString(),
      jsonTagTrade: trade.toString(),
      jsonTagDividend: dividend.toString(),
      jsonTagSavings: savings.toString(),
    };

    return jsonMap;
  }



}