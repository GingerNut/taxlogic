class Date{
  static const JANUARY = 1;
  static const FEBRUARY = 2;
  static const MARCH = 3;
  static const APRIL = 4;
  static const MAY = 5;
  static const JUNE = 6;
  static const JULY = 7;
  static const AUGUST = 8;
  static const SEPTEMBER = 9;
  static const OCTOBER = 10;
  static const NOVEMBER = 11;
  static const DECEMBER = 12;


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

  Date subtractMonths(int months){

    int startYear = year;

    int fullNewYears = months~/12;
    startYear -= fullNewYears;
    months -= fullNewYears *12;

    int startMonth = month - months;
    if(startMonth < 1) {
      startMonth += 12;
      startYear -=1;
    }

    int startDay = day;

    switch(startMonth){

      case APRIL:
      case JUNE:
      case SEPTEMBER:
      case NOVEMBER:
        if(startDay > 30) startDay = 30;
        break;

      case FEBRUARY:
        int maxDays = isleap(year) ? 29 : 28;
        if(startDay > maxDays) startDay = maxDays;
        break;

    default:

      break;
    }
    return new Date(startDay, startMonth, startYear);
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

  static bool isleap(int year){
    if(((year % (4) == 0) && (year %(100) != 0)) || (year %(400) == 0)){
      return true;
    } else return false;

  }


}

