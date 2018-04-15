import 'package:taxlogic/src/utilities/history.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class RateHistory extends History<Date>{
  RateHistory() : super();

  RateHistory.fromList(List<RateChange> history) : super.fromList(history);

  List<RatePeriod> getRatePeriods(Period period){
    List<RatePeriod> periods = new List();

    Date lastDate = period.start;
    num lastRate = valueAt(lastDate);

    Date nextDate = nextChange(lastDate);

    while(nextDate != null && !(nextDate>period.end) ){

      RatePeriod ratePeriod = new RatePeriod(new Period(lastDate, nextDate + (-1)), lastRate);
      periods.add(ratePeriod);

      lastDate = nextDate;
      lastRate = valueAt(lastDate);
      nextDate = nextChange(lastDate);

    }

    if(lastDate < period.end){
      periods.add(new RatePeriod(new Period(lastDate, period.end), valueAt(period.end)));
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


  Date getZero() => new Date(1,1,90);

  Change newChange(Date date, dynamic amount) => new RateChange(date, amount);
}

class RateChange extends Change<Date>{

  RateChange(Date date, num rate) : super(date, rate);

}



class RatePeriod{
  final Period period;
  final num rate;

  RatePeriod(this.period, this.rate);



  printRatePeriod(){
    print('Rate $rate from ${period.start.day} ${period.start.month} ${period.start.year} to ${period.end.day} ${period.end.month} ${period.end.year}');

  }

}

