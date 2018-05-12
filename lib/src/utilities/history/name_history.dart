import 'package:taxlogic/src/utilities/history/history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class NameHistory extends Diary{


  set(String s) {
    events.add(new NameChange(null, s));
  }



}

class NameChange extends Event{
  NameChange(Date date, this.name){
    super.date = date;
  }

  String name;
}