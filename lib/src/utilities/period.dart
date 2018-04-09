import 'package:taxlogic/src/utilities/date.dart';


class Period{

  Date start;
  Date end;

  int get duration => end.dateTime.difference(start.dateTime).inDays;
  int get days => end.dateTime.difference(start.dateTime).inDays + 1;

  Period(Date one, Date two){
    if(one < two){
      this.start = one;
      this.end = two;
    } else {
      this.start = two;
      this.end = one;

    }

  }

  bool includes(Date day){

    if(day < start) return false;
    if(day > end) return false;
    return true;
  }

  num completeMonths(){

    int years = 0;
    int months = 0;

    if(end.month > start.month){
      months = end.month - start.month;
      years = end.year - start.year;
    } else if(end.month == start.month){
      years = end.year - start.year;
    } else {
      months = end.month + (12 - start.month);
      years = end.year - start.year - 1;
    }

    if(end.day < start.day) months -= 1;

    return years * 12 + months;

  }

  static Period monthsTo(Date date, int months){

    Date start = date.subtractMonths(months) + 1;

    return new Period(start, date);
  }


  static int overlap(Period one, Period two){

    if(one.start == null) one.start = two.start;
    if(one.end == null) one.end = two.end;
    if(two.start == null) two.start = one.start;
    if(two.end == null) two.end = one.end;

    Period overall = combinePeriods(one, two);

    if(overall.days < one.days + two.days) return one.days + two.days - overall.days;

    else return 0;
  }

  static Period combinePeriods(Period one, Period two){
    Date first = one.start < two.start ? one.start : two.start;

    Date second = one.end > two.end ? one.end : two.end;

    return new Period(first, second);

  }

  static List<Period> overlappingPeriods(List<Period> periods){
    bool overlap = false;
    List<Period> overlapping = new List();

    for(int i = 0; i < periods.length; i ++){
      Period period = periods[i];

      for(int j = 0 ; j < periods.length ; j++){
        if(i == j) continue;
        Period compare = periods[j];

        if(Period.overlap(period, compare)>0) {
          overlap = true;
          break;
        }

      }

      if(overlap) overlapping.add(period);

    }
    return overlapping;

  }

  static List<Period> consolidatePeriods(List<Period> periods){

    if(periods != null) periods = sortPeriods(periods);
    else return null;

    List<Period> consolidated = new List();

    while (periods.length > 1){

      Period one = periods[0];

      Period two = periods[1];

      if(Period.overlap(one, two) > 0){
        periods.remove(one);
        periods.remove(two);
        consolidated.add(Period.combinePeriods(one, two));

      } else {
        periods.remove(one);
        consolidated.add(one);

      }

    }

    return consolidated;

  }

  static List<Period> sortPeriods(List<Period> periods){

    if(periods.length ==0) return null;
    if(periods.length == 1) return periods;

    List<Period> sorted = new List();

    while(periods.length > 0){

      Period firstPeriod = periods[0];
      Date first = firstPeriod.start;

      for(int i = 1 ; i < periods.length ; i ++){

        if(periods[i].start < first){
          firstPeriod = periods[i];
          first = firstPeriod.start;
        }
      }

      sorted.add(firstPeriod);
      periods.remove(firstPeriod);

    }

   return sorted;

  }

  num leapDaysInPeriod(){
    // find how many 28 Febs there are



    return 0;
  }

  void printPeriod(){
    print('period start ${start.day} ${start.month} ${start.year} and end ${end.day} ${end.month} ${end.year}');

  }

  static void printList(List<Period> periods){
    periods.forEach((period){
      period.printPeriod();
    });

  }


}

