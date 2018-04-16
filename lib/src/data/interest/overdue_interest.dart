import 'package:taxlogic/src/utilities/history/num_history.dart';
import 'package:taxlogic/src/utilities/date.dart';


class OverdueInterest{
  static NumHistory overdueInterest = new NumHistory.fromList([
    new NumChange(new Date(27,1,09),3.50),
    new NumChange(new Date(24,3,09),2.50),
    new NumChange(new Date(29,9,09),3.00),
    new NumChange(new Date(23,8,16),2.75),
    new NumChange(new Date(21,11,17),3.00),

  ]);






}