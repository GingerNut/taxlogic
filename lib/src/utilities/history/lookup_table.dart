


abstract class LookupTable<T>{
  List<TableEntry> history = new List();

  LookupTable();
  LookupTable.fromList(this.history);

  TableEntry get(int index) => history[index];

  add(TableEntry change){
    if(history.length == 0) setNil();
    history.add(change);
  }


  setNil();

  getZero();


  sort(){
    // TODO sort routine for RateHistory
  }



  TableEntry getEntry(T threshold){

    TableEntry entry = history[0];
    int i = 1;

    while(i < history.length && !(history[i].threshold > threshold)){

      entry = get(i);

      i++;
    }
    return entry;
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


abstract class TableEntry<T>{
  TableEntry(this.threshold);

  final T threshold;

}