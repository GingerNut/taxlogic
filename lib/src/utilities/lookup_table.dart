


abstract class LookupTable<T>{
  List<Change> history = new List();

  LookupTable.fromList(this.history);



  Change changeAt(T threshold){
    Change change = history[0];

    int i = 1;

    while(i < history.length && !(history[i].threshold > threshold)){

      change = history[i];

      i++;
    }
    return change;
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

  sort(){


  }

  Change newChange(T threshol, dynamic amount);

}


abstract class Change<T>{
  Change(this.threshold, this.amount);

  final T threshold;
  final dynamic amount;

}