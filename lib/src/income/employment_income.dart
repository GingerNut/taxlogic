import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';


class EmploymentIncome extends Income{
  EmploymentIncome(this.employment, TaxPosition taxPosition) : super(employment, taxPosition);

  Employment employment;

  num carBenefit(){
    num benefit = 0;

    employment.companyCars.forEach((car){

      if(car.ceaseToBeAvailable == null || car.ceaseToBeAvailable > taxPosition.period.start && car.madeAvailable < taxPosition.period.end){
        num thisCar = TaxData.CompanyCarRate(taxPosition.period.end.year, car.diesel, car.CO2);

        //print(thisCar);
      }


    });
    return benefit;
  }


  num get income {
    if(manualSet) return manualSetIncome;

    num income = activity.annualIncome.overallAmount(taxPosition.period);

    if (employment.termination != null && taxPosition.period.includes(employment.termination.date)) {
      income += employment.termination.amount;
    }

    income += carBenefit();

    return income;
  }

}