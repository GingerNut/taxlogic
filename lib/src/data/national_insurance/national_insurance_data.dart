import 'national_insurance_data_2016.dart';
import 'national_insurance_data_2017.dart';
import 'national_insurance_data_2018.dart';
import 'national_insurance_data_2019.dart';


abstract class NationalInsuranceData{

  // class 1
  num C1LowerEarningsLimit;
  num C1PrimaryThreshold;
  num C1SecondaryThreshold;
  num C1UpperAccrualPoint;
  num C1UpperEarningsLimit;
  num C1UpperSecondaryThreshold;
  num C1ApprenticeUpperSecondaryThreshold;

  num C1RateToUEL;
  num C1RateAboveUEL;
  num C1RateContractedOut;
  num C1MarriedWomensRate;
  num C1RateSecondary;
  num C1RateSecondaryContractedOut;

  //class 2
  num C2SmallProfitsThreshold;
  num C2Cl2RatePerWeek;

  // class 4

  num C4LowerProfitLimit;
  num C4UpperProfitLimit;
  num C4RateToUpperLimit;
  num C4RateAboveUpperLimit;



  static NationalInsuranceData get(int year){

    NationalInsuranceData taxData;

    switch(year){
      case 2016:
        taxData = new NationalInsuranceData2016();
        break;

      case 2017:
        taxData = new NationalInsuranceData2017();
        break;

      case 2018:
        taxData = new NationalInsuranceData2018();
        break;

      case 2019:
        taxData = new NationalInsuranceData2019();
        break;
    }

    return taxData;

  }


}
