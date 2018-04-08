import '../../utilities/utilities.dart';
import 'company_car_2018.dart';

class CompanyCarRates{

  RateTable table;

  static CompanyCarRates get(int year){

    CompanyCarRates carRates;

    if(year > 2018) year = 2018;

    switch(year){
      case 2018:
        carRates = new CompanyCar2018();
        break;

    }

    return carRates;

  }


}