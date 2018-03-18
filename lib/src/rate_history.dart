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

  Date lastChange(Date date){

    Date lastDate = history[0].date;

    int i = 1;

    while(i < history.length && history[i].date < date){

        lastDate = history[i].date;

      i++;
    }
    return lastDate;


  }

  Date nextChange(Date date){

    int i = 0;

    while(i < history.length && history[i].date < date) {
      i++;
    }

    if(i < history.length) return history[i].date;

    return null;
  }


  List<RatePeriod> getRatePeriods(Period period){
    List<RatePeriod> periods = new List();

    Date lastDate = period.start;
    num lastRate = rateAt(lastDate);

    Date nextDate = nextChange(lastDate);

    while(nextDate != null && !(nextDate>period.end) ){
      RatePeriod ratePeriod = new RatePeriod(new Period(lastDate, nextDate), lastRate);
      periods.add(ratePeriod);

      lastDate = nextDate;
      lastRate = rateAt(lastDate);
      nextDate = nextChange(lastDate);

    }

    return periods;
  }


}

class RateChange{
  final Date date;
  final num rate;

  RateChange(this.date, this.rate);

}

class RatePeriod{
  final Period period;
  final num rate;

  RatePeriod(this.period, this.rate);

}