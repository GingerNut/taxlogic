import '../../date.dart';
import '../../entities/entity.dart';

class CapitalAllowances{

  static num getAIA(Date date, Entity entity){

    int day = entity.type == Class.company ? 1 : 6 ;

    if(date < new Date (day ,4, 2010)) return 50000;
    else if (date < new Date(day , 4 , 2012)) return 100000;
    else if (date < new Date(1 , 1 , 2013)) return 25000;
    else if (date < new Date(day , 4 , 2014)) return 250000;
    else if (date < new Date(1 , 1 , 2015)) return 500000;
    else return 200000;
  }

}