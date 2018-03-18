import 'period.dart';
import 'date.dart';


class RateHistory{

  final List<RateChange> history;

  RateHistory(this.history);


  num rateAt(Date date){
    num rate = history[0].rate;

    int i = 1;

    while(i < history.length){
      if (!(history[i].date < date)){
        rate = history[i].rate;
        break;
      }
      i++;
      }
    return rate;
  }




}

class RateChange{
  final Date date;
  final num rate;

  RateChange(this.date, this.rate);

}

class RatePeriod{
  Period period;
  num rate;

}