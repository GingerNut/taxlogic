import 'package:taxlogic/src/utilities/utilities.dart';


abstract class Diary{

  List<Event> events = new List();

  add(Event event){
    events.add(event);
    sort();
  }

  Event valueAt(Date threshold){

    Event entry = events[0];
    int i = 1;

    while(i < events.length && (threshold == null || !(events[i].date > threshold))){

      entry = events[i];

      i++;
    }
    return entry;
  }


  Date lastChange(Date threshold){

    Date lastDate = events[0].date;

    int i = 1;

    while(i < events.length && events[i].date < threshold){

      lastDate = events[i].date;

      i++;
    }
    return lastDate;

  }

  Date nextChange(Date date){

    int i = 0;

    while(i < events.length && !(events[i].date > date)) {
      i++;
    }

    if(i < events.length) return events[i].date;

    return null;
  }



  sort(){
    List<Event> newEvents = new List();

    while (events.length > 0){
      Event earliest = events[0];

      events.forEach((e){
        if(e.date < earliest.date){
          earliest = e;

        }
      });

      events.remove(earliest);
      newEvents.add(earliest);

    }

    events = newEvents;

  }


}

abstract class Event{

  Date _date;

  set date (Date date) => _date = date;

  Date get date{

    if(_date == null) return new Date(1,1,1900);
    else return _date;

  }
  
}



