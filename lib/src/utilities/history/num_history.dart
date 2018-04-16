import 'package:taxlogic/src/utilities/history/history.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class NumHistory extends History<num> {
  NumHistory() : super();

  NumHistory.fromList(List<NumChange> history) : super.fromList(history);

  List<NumPeriod> getRatePeriods(Period period) {
    List<NumPeriod> periods = new List();

    Date lastDate = period.start;
    num lastRate = valueAt(lastDate);

    Date nextDate = nextChange(lastDate);

    while (nextDate != null && !(nextDate > period.end)) {
      NumPeriod ratePeriod = new NumPeriod(
          new Period(lastDate, nextDate + (-1)), lastRate);
      periods.add(ratePeriod);

      lastDate = nextDate;
      lastRate = valueAt(lastDate);
      nextDate = nextChange(lastDate);
    }

    if (lastDate < period.end) {
      periods.add(new NumPeriod(
          new Period(lastDate, period.end), valueAt(period.end)));
    }

    return periods;
  }

  num overallAmount(Period period) {
    if (history.length == 0) return 0;

    List<NumPeriod> periods = getRatePeriods(period);

    num overallRate = 0;

    periods.forEach((part) {
      overallRate += part.rate * part.period.days / period.days;
    });

    overallRate = overallRate * period.days / 365;

    return Utilities.roundTax(overallRate);
  }

  num averageRate(Period period) {
    List<NumPeriod> periods = getRatePeriods(period);

    num average = 0;

    periods.forEach((part) {
      average += part.rate * part.period.days / period.days;
    });

    return Utilities.roundTax(average);
  }


  Date getZero() => new Date(1, 1, 90);

  Change newChange(Date date, dynamic amount) => new NumChange(date, amount);

  @override
  setNil() => set(0);

}

class NumChange extends Change<num>{

  NumChange(Date date, num rate) : super(date, rate);

}



class NumPeriod{
  final Period period;
  final num rate;

  NumPeriod(this.period, this.rate);



  printRatePeriod(){
    print('Rate $rate from ${period.start.day} ${period.start.month} ${period.start.year} to ${period.end.day} ${period.end.month} ${period.end.year}');

  }

}

