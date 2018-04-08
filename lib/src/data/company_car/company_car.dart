import '../../utilities/utilities.dart';
import 'company_car_petrol_2018.dart';
import 'company_car_diesel_2018.dart';

class CompanyCarRates{

  RateTable table;

  static CompanyCarRates get(int year, bool diesel){

    CompanyCarRates carRates;

    if(year > 2018) year = 2018;

    switch(year){
      case 2018:
        carRates = diesel ? new CompanyCarDiesel2018() : new CompanyCarPetrol2018();
        break;

    }

    return carRates;

  }


}