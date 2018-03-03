import 'date.dart';


class Period{

  final Date start;
  final Date end;

  int get duration => end.dateTime.difference(start.dateTime).inDays;

  Period(this.start, this.end);


}

