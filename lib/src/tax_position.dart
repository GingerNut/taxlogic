import 'taxation/income_tax.dart';
import 'taxation/national_insurance.dart';
import 'person.dart';
import 'tax_year.dart';
import 'assets/chargeable_assets.dart';
import 'taxation/capital_gains.dart';

class TaxPosition{
  static const String jsonTagCode = "code";
  static const String jsonTagYear = "year";
  static const String jsonTagEarnings = "earnings";
  static const String jsonTagTrade = "trade";
  static const String jsonTagDividend = "dividend";
  static const String jsonTagSavings = "savings";

  Person person;
  TaxPosition previousTaxPosition;
  TaxYear taxYear;
  int year;

  List<ChargeableAsset> disposals = new List();
  num earnings = 0;
  num trade = 0;
  num dividend = 0;
  num savings = 0;
  num capitalGains = 0;

  IncomeTaxPosition incomeTax;
  NationalInsurancePosition nicPosition;
  CapitalGainsTaxPosition capitalGainsTaxPosition;

  TaxPosition(this.person, this.year){
    taxYear = new TaxYear(year);
    incomeTax = new IncomeTaxPosition(person, this);
    nicPosition = new NationalInsurancePosition(person, this);
    capitalGainsTaxPosition = new CapitalGainsTaxPosition(person, this);

  }

  refreshDisposals() {
    disposals.clear();
    person.assets.forEach((asset) {
        if(asset.saleDate != null){
          if(taxYear.includes(asset.saleDate)){
            disposals.add(asset);
          }
        }
    });

  }

  static TaxPosition fromMap(Map map, person){

    TaxPosition position = new TaxPosition(person, int.parse(map['year']));

    position.earnings = int.parse(map[jsonTagEarnings]);
    position.trade = int.parse(map[jsonTagTrade]);
    position.dividend = int.parse(map[jsonTagDividend]);
    position.savings = int.parse(map[jsonTagSavings]);

    return position;
  }

  Map toMap(){
    Map jsonMap = {
      jsonTagCode: person.code,
      jsonTagYear: year.toString(),
      jsonTagEarnings: earnings.toString(),
      jsonTagTrade: trade.toString(),
      jsonTagDividend: dividend.toString(),
      jsonTagSavings: savings.toString(),
    };

    return jsonMap;
  }



}