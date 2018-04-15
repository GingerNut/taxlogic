

abstract class History<T>{
  History();
  History.fromList(this.history);

  List<Change> history = new List();

  Change get(int index) => history[index];

  add(Change change){
    if(history.length == 0) set(0);
    history.add(change);
  }

  set (dynamic amount){
    history.add(newChange(getZero(), amount));

    sort();
  }

  Change newChange(T threshold, dynamic amount);

  T getZero();

  sort(){
    // TODO sort routine for RateHistory
  }

  dynamic valueAt(T threshold){

    dynamic rate = get(0).amount;

    int i = 1;

    while(i < history.length && !(history[i].threshold > threshold)){

      rate = get(i).amount;

      i++;
    }
    return rate;
  }

  T lastChange(T threshold){

    T lastDate = history[0].threshold;

    int i = 1;

    while(i < history.length && history[i].threshold < threshold){

      lastDate = history[i].threshold;

      i++;
    }
    return lastDate;


  }

  T nextChange(T date){

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

    final T threshold;
    final dynamic amount;

}

