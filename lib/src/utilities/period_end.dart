
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class PeriodEnd{
  final int month;
  final int day;

  PeriodEnd(this.day, this.month);

  Date next(Date date){

    int year = date.year;

    if(date.month > month) year += 1;
    else if(date.month == month && date.day > day) year += 1;

    return new Date(day, month, year);

  }


  Period end(int year) {

    Date start = new Date(day, month, year-1) + 1;
    Date end = new Date(day, month, year);

    return new Period(start, end);
  }}