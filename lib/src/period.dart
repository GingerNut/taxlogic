import 'date.dart';


class Period{

  final Date start;
  final Date end;

  int get duration => end.dateTime.difference(start.dateTime).inDays;
  int get days => end.dateTime.difference(start.dateTime).inDays + 1;

  Period(this.start, this.end);

  bool includes(Date day){

    if(day < start) return false;
    if(day > end) return false;
    return true;
  }


}

