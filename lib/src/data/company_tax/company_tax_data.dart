import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history/num_history.dart';

import 'package:taxlogic/src/utilities/period.dart';

abstract class CompanyTaxData{
  static NumHistory companyMainRate = new NumHistory.fromList([
    new NumChange(new Date(1,4,14),0.20),
    new NumChange(new Date(1,4,17),0.19),
    new NumChange(new Date(1,4,20),0.17),

  ]);


  static num getMainRate(Date date)=> companyMainRate.valueAt(date);

  static List<NumPeriod> getRatePeriods(Period period)=> companyMainRate.getRatePeriods(period);


}
