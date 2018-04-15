import 'package:taxlogic/src/utilities/rate_history.dart';
import 'package:taxlogic/src/utilities/date.dart';


class OverdueInterest{
  static RateHistory overdueInterest = new RateHistory.fromList([
    new RateChange(new Date(27,1,09),3.50),
    new RateChange(new Date(24,3,09),2.50),
    new RateChange(new Date(29,9,09),3.00),
    new RateChange(new Date(23,8,16),2.75),
    new RateChange(new Date(21,11,17),3.00),

  ]);






}