import 'package:taxlogic/src/utilities/utilities.dart';


abstract class History<T>{
  History();
  History.fromList(this.history);

  List<Change> history = new List();

  Change get(int index) => history[index];

  add(Change change){
    if(history.length == 0) setNil();
    history.add(change);
  }

  set (T  amount){
    history.add(newChange(getZero(), amount));

    sort();
  }

  setNil();

  Change newChange(Date threshold, T  amount);

  Date getZero();

  sort(){
    // TODO sort routine for RateHistory
  }

  T valueAt(Date threshold){

    T  rate = get(0).amount;

    int i = 1;

    while(i < history.length && !(history[i].threshold > threshold)){

      rate = get(i).amount;

      i++;
    }
    return rate;
  }

  Date lastChange(Date threshold){

    Date lastDate = history[0].threshold;

    int i = 1;

    while(i < history.length && history[i].threshold < threshold){

      lastDate = history[i].threshold;

      i++;
    }
    return lastDate;


  }

  Date nextChange(Date date){

    int i = 0;

    while(i < history.length && !(history[i].threshold > date)) {
      i++;
    }

    if(i < history.length) return history[i].threshold;

    return null;
  }


}

abstract class Change<T>{
  Change(this.threshold, this.amount);

    final Date threshold;
    final T  amount;

}

