import '../../utilities/utilities.dart';
import 'company_car_petrol_2018.dart';
import 'company_car_diesel_2018.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/data/company_car/company_car_electric_2018.dart';

class CompanyCarRates{

  RateTable table;

  static CompanyCarRates get(int year, int engineType){

    CompanyCarRates carRates;

    if(year > 2018) year = 2018;

    switch(year){
      case 2018:
        switch(engineType){
          case Car.PETROL : return new CompanyCarPetrol2018();
          case Car.DIESEL : return new CompanyCarDiesel2018();
          case Car.ELECTRIC : return new CompanyCarElectric2018();
        }

        break;

    }

    return carRates;

  }


}