import 'package:taxlogic/src/utilities/history/lookup_table.dart';
import 'package:taxlogic/src/utilities/utilities.dart';


abstract class History<T> extends LookupTable<Date>{
  History() : super();

  History.fromList(List<TableEntry> history) : super.fromList(history);



  Change get(int index) => history[index];


  set (T  amount){
    history.add(newChange(getZero(), amount));

    sort();
  }



  Change newChange(Date threshold, T  amount);

  Date getZero() => new Date(1,1,1900);



  T valueAt(Date threshold) => (getEntry(threshold) as Change).amount;



}

abstract class Change<T> extends TableEntry<Date>{
  Change(this.date, this.amount) : super(date);

    final Date date;
    final T  amount;

}

