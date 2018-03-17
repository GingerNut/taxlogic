
import '../../taxlogic.dart';
import '../taxation/corporation_tax.dart';
import '../assets/trade.dart';
import '../assets/activity.dart';

class CompanyTaxPosition extends TaxPosition{
  static const String jsonTagCode = "code";
  static const String jsonTagYear = "year";
  static const String jsonTagEarnings = "earnings";
  static const String jsonTagTrade = "trade";
  static const String jsonTagDividend = "dividend";
  static const String jsonTagSavings = "savings";

  Activity activity;
  num dividend = 0;
  num capitalGains = 0;
  num income = 0;

  CorporationTax companyTax;


  num get basicRateAvailable =>0;

  CompanyTaxPosition(Entity entity, Period period) : super (entity, period){
    companyTax = new CorporationTax(entity, this);





  }




}