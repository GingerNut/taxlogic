import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class RateHistory{
  RateHistory(this.history);

  RateHistory.empty(){
    this.history = new List<RateChange>();
  }

  List<RateChange> history;

  add(RateChange change){
    history.add(change);
  }


  num rateAt(Date date){
    num rate = history[0].rate;

    int i = 1;

    while(i < history.length && !(history[i].date > date)){

        rate = history[i].rate;

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

    while(i < history.length && !(history[i].date > date)) {
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

      RatePeriod ratePeriod = new RatePeriod(new Period(lastDate, nextDate + (-1)), lastRate);
      periods.add(ratePeriod);

      lastDate = nextDate;
      lastRate = rateAt(lastDate);
      nextDate = nextChange(lastDate);

    }

    if(lastDate < period.end){
      periods.add(new RatePeriod(new Period(lastDate, period.end), rateAt(period.end)));
    }

    return periods;
  }


  num overallAmount(Period period){
    if(history.length ==0) return 0;

    List<RatePeriod> periods = getRatePeriods(period);

    num overallRate = 0;

    periods.forEach((part){
      overallRate += part.rate * part.period.days / period.days;
    });

    overallRate = overallRate * period.days / 365;

    return Utilities.roundTax(overallRate);

  }

  num averageRate(Period period){
    List<RatePeriod> periods = getRatePeriods(period);

    num average = 0;

    periods.forEach((part){
      average += part.rate * part.period.days / period.days;
    });

    return Utilities.roundTax(average);

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



  printRatePeriod(){
    print('Rate $rate from ${period.start.day} ${period.start.month} ${period.start.year} to ${period.end.day} ${period.end.month} ${period.end.year}');

  }

}