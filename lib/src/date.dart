class Date{

  DateTime dateTime;
  int day;
  int month;
  int year;

  Date (this.day, this.month, this.year){

    if(year< 50){
      year += 2000;
    } else if(year < 100){
      year +=1900;
    }

    dateTime = new DateTime(year, month, day);

  }

  Date.fromDateTime(this.dateTime){
    day = dateTime.day;
    month = dateTime.month;
    year = dateTime.year;
  }


  int operator -(Date other) => dateTime.difference(other.dateTime).inDays;

  Date operator +(num days)=> new Date.fromDateTime(dateTime.add(new Duration(days: days)));


   bool operator < (Date other){

     num difference = dateTime.difference(other.dateTime).inDays;

     return difference < 0;
  }

  bool operator > (Date other){

    num difference = dateTime.difference(other.dateTime).inDays;

    return difference > 0;
  }

}