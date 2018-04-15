import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/rate_history.dart';
import 'package:taxlogic/src/utilities/period.dart';

abstract class CompanyTaxData{
  static RateHistory companyMainRate = new RateHistory.fromList([
    new RateChange(new Date(1,4,14),0.20),
    new RateChange(new Date(1,4,17),0.19),
    new RateChange(new Date(1,4,20),0.17),

  ]);


  static num getMainRate(Date date)=> companyMainRate.valueAt(date);

  static List<RatePeriod> getRatePeriods(Period period)=> companyMainRate.getRatePeriods(period);


}
