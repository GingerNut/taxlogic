import '../../date.dart';
import '../../rate_history.dart';
import '../../period.dart';

abstract class CompanyTaxData{
  static RateHistory companyMainRate = new RateHistory([
    new RateChange(new Date(1,4,14),0.20),
    new RateChange(new Date(1,4,17),0.19),
    new RateChange(new Date(1,4,20),0.17),

  ]);


  static num getMainRate(Date date)=> companyMainRate.rateAt(date);

  static List<RatePeriod> getRatePeriods(Period period)=> companyMainRate.getRatePeriods(period);


}
