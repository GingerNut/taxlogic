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


}